# n8n Dockerfile for Railway Deployment
FROM n8nio/n8n:latest

# Railway provides PORT env var dynamically at runtime
# n8n will use PORT if available, otherwise defaults to 5678
ENV N8N_PROTOCOL=https
ENV N8N_BASIC_AUTH_ACTIVE=true

# Expose port (Railway will map to its dynamic PORT)
EXPOSE 5678

# Start n8n (Railway's PORT env var will be automatically used)
CMD ["n8n"]
