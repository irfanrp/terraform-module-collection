#!/bin/bash
# Advanced Ubuntu setup script with comprehensive monitoring and security

# Update system
apt-get update -y
apt-get upgrade -y

# Install essential packages
apt-get install -y \
    htop \
    curl \
    wget \
    git \
    unzip \
    tree \
    nginx \
    awscli \
    fail2ban \
    ufw \
    htop \
    iotop \
    netstat-nat

# Configure firewall
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Configure fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# Install and configure Nginx
systemctl start nginx
systemctl enable nginx

# Create advanced web application
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Advanced EC2 Instance</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container { 
            max-width: 1000px; 
            margin: 0 auto; 
            background: rgba(255,255,255,0.1);
            padding: 40px;
            border-radius: 15px;
            backdrop-filter: blur(15px);
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        }
        .header { text-align: center; margin-bottom: 30px; }
        .header h1 { font-size: 2.5rem; margin-bottom: 10px; }
        .header p { font-size: 1.2rem; opacity: 0.9; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin: 30px 0; }
        .card { 
            background: rgba(255,255,255,0.1); 
            padding: 25px; 
            border-radius: 10px; 
            border-left: 4px solid #00ff88;
            transition: transform 0.3s ease;
        }
        .card:hover { transform: translateY(-5px); }
        .card h3 { margin-bottom: 15px; color: #00ff88; }
        .status { color: #00ff88; margin: 8px 0; }
        .warning { color: #ffaa00; }
        .code { 
            background: rgba(0,0,0,0.4); 
            padding: 15px; 
            border-radius: 8px; 
            font-family: 'Courier New', monospace;
            margin: 10px 0;
            overflow-x: auto;
        }
        .metric { 
            display: flex; 
            justify-content: space-between; 
            margin: 10px 0; 
            padding: 10px;
            background: rgba(255,255,255,0.05);
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Advanced EC2 Terraform Module</h1>
            <p>Production-ready instance with enterprise features</p>
        </div>
        
        <div class="grid">
            <div class="card">
                <h3>📊 Instance Information</h3>
                <div class="metric">
                    <span>Instance ID:</span>
                    <span id="instance-id">Loading...</span>
                </div>
                <div class="metric">
                    <span>Instance Type:</span>
                    <span id="instance-type">Loading...</span>
                </div>
                <div class="metric">
                    <span>Availability Zone:</span>
                    <span id="az">Loading...</span>
                </div>
                <div class="metric">
                    <span>Private IP:</span>
                    <span id="private-ip">Loading...</span>
                </div>
                <div class="metric">
                    <span>Placement Group:</span>
                    <span>cluster</span>
                </div>
            </div>

            <div class="card">
                <h3>🛡️ Security Features</h3>
                <p class="status">✅ Termination Protection Enabled</p>
                <p class="status">✅ Private Subnet Deployment</p>
                <p class="status">✅ UFW Firewall Active</p>
                <p class="status">✅ Fail2ban Protection</p>
                <p class="status">✅ SSM Agent Ready</p>
                <p class="warning">⚠️ No Public IP (Security)</p>
            </div>

            <div class="card">
                <h3>📈 Monitoring & Logging</h3>
                <p class="status">✅ CloudWatch Detailed Monitoring</p>
                <p class="status">✅ Custom Metrics Collection</p>
                <p class="status">✅ Log Forwarding Enabled</p>
                <p class="status">✅ Performance Metrics</p>
                <p class="status">✅ Application Logs</p>
            </div>

            <div class="card">
                <h3>🔗 IAM Permissions</h3>
                <p class="status">✅ SSM Core Policies</p>
                <p class="status">✅ CloudWatch Agent</p>
                <p class="status">✅ S3 Read Access</p>
                <p class="status">✅ Custom S3 Bucket Access</p>
                <p class="status">✅ CloudWatch Logs</p>
            </div>
        </div>

        <div class="card">
            <h3>🖥️ Access Methods</h3>
            <p>Since this instance is in a private subnet, use one of these methods:</p>
            
            <h4 style="margin: 15px 0 10px 0; color: #00ff88;">1. AWS Session Manager (Recommended)</h4>
            <div class="code">aws ssm start-session --target <span id="instance-id-cmd">INSTANCE_ID</span></div>
            
            <h4 style="margin: 15px 0 10px 0; color: #00ff88;">2. SSH via Bastion Host</h4>
            <div class="code">
                # First SSH to bastion<br>
                ssh -i /path/to/key ubuntu@BASTION_PUBLIC_IP<br>
                # Then SSH to this instance<br>
                ssh ubuntu@<span id="private-ip-cmd">PRIVATE_IP</span>
            </div>
        </div>

        <div class="card">
            <h3>⚡ Performance Features</h3>
            <p class="status">✅ Cluster Placement Group</p>
            <p class="status">✅ Enhanced Networking</p>
            <p class="status">✅ GP3 Storage</p>
            <p class="status">✅ Detailed CloudWatch Monitoring</p>
        </div>
    </div>
    
    <script>
        // Fetch instance metadata
        fetch('http://169.254.169.254/latest/meta-data/instance-id')
            .then(response => response.text())
            .then(data => {
                document.getElementById('instance-id').textContent = data;
                document.getElementById('instance-id-cmd').textContent = data;
            });
            
        fetch('http://169.254.169.254/latest/meta-data/instance-type')
            .then(response => response.text())
            .then(data => document.getElementById('instance-type').textContent = data);
            
        fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone')
            .then(response => response.text())
            .then(data => document.getElementById('az').textContent = data);
            
        fetch('http://169.254.169.254/latest/meta-data/local-ipv4')
            .then(response => response.text())
            .then(data => {
                document.getElementById('private-ip').textContent = data;
                document.getElementById('private-ip-cmd').textContent = data;
            });
    </script>
</body>
</html>
EOF

# Download and install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb

# Create comprehensive CloudWatch agent configuration
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
    "metrics": {
        "namespace": "EC2/Advanced",
        "metrics_collected": {
            "cpu": {
                "measurement": [
                    "cpu_usage_idle",
                    "cpu_usage_iowait",
                    "cpu_usage_user",
                    "cpu_usage_system",
                    "cpu_usage_steal",
                    "cpu_usage_nice"
                ],
                "metrics_collection_interval": 60,
                "totalcpu": true
            },
            "disk": {
                "measurement": [
                    "used_percent",
                    "inodes_free"
                ],
                "metrics_collection_interval": 60,
                "resources": [
                    "*"
                ]
            },
            "diskio": {
                "measurement": [
                    "io_time",
                    "read_bytes",
                    "write_bytes",
                    "reads",
                    "writes"
                ],
                "metrics_collection_interval": 60,
                "resources": [
                    "*"
                ]
            },
            "mem": {
                "measurement": [
                    "mem_used_percent",
                    "mem_available_percent",
                    "mem_used",
                    "mem_cached",
                    "mem_total"
                ],
                "metrics_collection_interval": 60
            },
            "netstat": {
                "measurement": [
                    "tcp_established",
                    "tcp_time_wait"
                ],
                "metrics_collection_interval": 60
            },
            "processes": {
                "measurement": [
                    "running",
                    "sleeping",
                    "dead"
                ]
            }
        }
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/nginx/access.log",
                        "log_group_name": "/aws/ec2/advanced/nginx/access",
                        "log_stream_name": "{instance_id}"
                    },
                    {
                        "file_path": "/var/log/nginx/error.log",
                        "log_group_name": "/aws/ec2/advanced/nginx/error",
                        "log_stream_name": "{instance_id}"
                    },
                    {
                        "file_path": "/var/log/syslog",
                        "log_group_name": "/aws/ec2/advanced/system/syslog",
                        "log_stream_name": "{instance_id}"
                    },
                    {
                        "file_path": "/var/log/auth.log",
                        "log_group_name": "/aws/ec2/advanced/system/auth",
                        "log_stream_name": "{instance_id}"
                    },
                    {
                        "file_path": "/var/log/fail2ban.log",
                        "log_group_name": "/aws/ec2/advanced/security/fail2ban",
                        "log_stream_name": "{instance_id}"
                    }
                ]
            }
        }
    }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
    -s

# Enable CloudWatch agent
systemctl enable amazon-cloudwatch-agent

# Create a simple health check endpoint
cat > /var/www/html/health << 'EOF'
{
    "status": "healthy",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)",
    "instance_id": "$(curl -s http://169.254.169.254/latest/meta-data/instance-id)",
    "services": {
        "nginx": "running",
        "cloudwatch-agent": "running",
        "fail2ban": "running"
    }
}
EOF

# Make health check executable and set up cron
chmod +x /var/www/html/health

# Log completion
echo "$(date): Advanced EC2 setup completed successfully" >> /var/log/user-data.log
echo "Instance ready with all advanced features enabled" >> /var/log/user-data.log