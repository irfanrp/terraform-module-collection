const fs = require('fs');

async function run() {
  try {
    const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
    const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
    const PR_NUMBER = (process.env.PR_NUMBER || '').trim();
    const repo = process.env.GITHUB_REPOSITORY;

    if (!GEMINI_API_KEY) {
      console.log('[INFO] GEMINI_API_KEY not set — exiting.');
      return;
    }

    const diff = fs.existsSync('pr.diff') ? fs.readFileSync('pr.diff', 'utf8') : '';
    const truncated = diff.length > 60000 ? diff.slice(0, 60000) + '\n...[truncated]...' : diff;
    const prompt = `You are an expert Terraform reviewer. Summarize the following diff and list EXACTLY 3 actionable suggestions (security, best-practices, docs). Be concise.\n\n${truncated}`;

  // Using gemini-2.5-flash model as requested. Change MODEL if your key/project exposes a different variant (e.g. gemini-2.5-flash).
  const MODEL = 'gemini-2.5-flash';
  const url = `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateText?key=${GEMINI_API_KEY}`;
    const payload = { prompt: { text: prompt }, temperature: 0.3, maxOutputTokens: 512 };

    const res = await fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) });
    const body = await res.json();
    if (res.status >= 400) {
      console.error('Model API error', res.status, body);
      fs.writeFileSync('ai-summary.md', 'Model API error ' + res.status + '\n' + JSON.stringify(body, null, 2));
      return;
    }

    const text = body?.candidates?.[0]?.output || JSON.stringify(body);
    const comment = `### 🤖 AI PR Summary\n\n${text}\n\n---\n_Diff chars: ${diff.length} (truncated: ${diff.length !== truncated.length})_`;
    fs.writeFileSync('ai-summary.md', comment);

    if (!PR_NUMBER) {
      console.log('No PR number provided, skipping posting comment.');
      return;
    }

    const ghRes = await fetch(`https://api.github.com/repos/${repo}/issues/${PR_NUMBER}/comments`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `token ${GITHUB_TOKEN}`
      },
      body: JSON.stringify({ body: comment })
    });
    console.log('Posted comment status', ghRes.status);
  } catch (e) {
    console.error('Unexpected error in pr-summarizer:', e && (e.stack || e.message || e));
    fs.writeFileSync('ai-summary.md', 'Unexpected error: ' + (e && (e.stack || e.message || String(e))));
    process.exitCode = 1;
  }
}

run();
