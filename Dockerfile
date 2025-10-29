# n8n Dockerfile for Railway Deployment
FROM n8nio/n8n:latest

# Set working directory
WORKDIR /data

# Railway provides PORT env var dynamically
# n8n reads PORT env var automatically
ENV N8N_PROTOCOL=https
ENV N8N_BASIC_AUTH_ACTIVE=true

# Expose the port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
