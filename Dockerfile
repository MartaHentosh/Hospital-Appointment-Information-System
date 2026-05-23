# Use official Python slim image
FROM python:3.11-slim

# Create non-root user for security
RUN groupadd -r django && useradd -r -g django django

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Upgrade pip
RUN pip install --upgrade pip

# Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . /app/

# Create staticfiles directory and set permissions
RUN mkdir -p /app/staticfiles && chown -R django:django /app

# Switch to non-root user
USER django

# Expose port
EXPOSE 8000

# Run gunicorn
CMD ["gunicorn", "hospital_appointment_and_information_system.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]