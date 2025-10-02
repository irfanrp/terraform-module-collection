#!/bin/bash
# Example user data script for EC2 basic example
# This script sets up a simple web server

# Update system
yum update -y

# Install Apache and start it
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Create a simple web page
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>EC2 Example Instance</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 40px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
        }
        .container { 
            max-width: 800px; 
            margin: 0 auto; 
            background: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        .info { 
            background: rgba(255,255,255,0.1); 
            padding: 20px; 
            border-radius: 5px; 
            margin: 15px 0; 
            border-left: 4px solid #00ff88;
        }
        .status { color: #00ff88; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Terraform EC2 Module Demo</h1>
        <p>This instance was created using the enhanced EC2 Terraform module!</p>
        
        <div class="info">
            <h3>Instance Details</h3>
            <p><strong>Instance ID:</strong> <span id="instance-id">Loading...</span></p>
            <p><strong>Instance Type:</strong> <span id="instance-type">Loading...</span></p>
            <p><strong>Availability Zone:</strong> <span id="az">Loading...</span></p>
            <p><strong>Public IP:</strong> <span id="public-ip">Loading...</span></p>
            <p><strong>Private IP:</strong> <span id="private-ip">Loading...</span></p>
        </div>
        
        <div class="info">
            <h3>Module Features Enabled</h3>
            <p class="status">✅ SSM Agent - Ready for Session Manager</p>
            <p class="status">✅ CloudWatch Logs - System logs forwarded</p>
            <p class="status">✅ CloudWatch Metrics - Custom metrics enabled</p>
            <p class="status">✅ Apache Web Server - Running</p>
            <p class="status">✅ User Data Script - Executed successfully</p>
        </div>

        <div class="info">
            <h3>Connect via Session Manager</h3>
            <p>No SSH keys needed! Use AWS CLI:</p>
            <code style="background: rgba(0,0,0,0.3); padding: 10px; display: block; border-radius: 5px;">
                aws ssm start-session --target <span id="instance-id-cmd">INSTANCE_ID</span>
            </code>
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
            
        fetch('http://169.254.169.254/latest/meta-data/public-ipv4')
            .then(response => response.text())
            .then(data => document.getElementById('public-ip').textContent = data)
            .catch(() => document.getElementById('public-ip').textContent = 'N/A');
            
        fetch('http://169.254.169.254/latest/meta-data/local-ipv4')
            .then(response => response.text())
            .then(data => document.getElementById('private-ip').textContent = data);
    </script>
</body>
</html>
EOF

# Install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# Create basic CloudWatch agent config
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
    "metrics": {
        "namespace": "EC2/Example",
        "metrics_collected": {
            "cpu": {
                "measurement": ["cpu_usage_idle", "cpu_usage_user", "cpu_usage_system"],
                "metrics_collection_interval": 300
            },
            "disk": {
                "measurement": ["used_percent"],
                "metrics_collection_interval": 300,
                "resources": ["*"]
            },
            "mem": {
                "measurement": ["mem_used_percent"],
                "metrics_collection_interval": 300
            }
        }
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/httpd/access_log",
                        "log_group_name": "/aws/ec2/example/httpd/access",
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

# Log completion
echo "$(date): EC2 example user data completed successfully" >> /var/log/user-data.log