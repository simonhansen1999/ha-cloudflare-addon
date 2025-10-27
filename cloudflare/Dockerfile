FROM python:3.12-alpine

WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Install curl (needed for cloudflared download)
RUN apk add --no-cache curl

# Copy add-on files
COPY . /app

# Make run.sh executable
RUN chmod +x /app/run.sh

CMD ["/app/run.sh"]
