pipeline {
    agent any

    environment {
        APP_PORT = "8000"
        APP_HOST = "0.0.0.0"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/Mr-Maqsood/django-notes-app.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv venv
                    ./venv/bin/pip install --upgrade pip
                    ./venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Run with Gunicorn') {
            steps {
                sh '''
                    pkill -f "gunicorn" || true
                    mkdir -p logs
                    nohup ./venv/bin/gunicorn notesapp.wsgi:application --bind $APP_HOST:$APP_PORT --access-logfile logs/access.log --error-logfile logs/error.log &
                    sleep 5
                    echo "✅ Django app started successfully on port $APP_PORT"
                    ps aux | grep gunicorn
                    tail -n 10 logs/access.log || true
                    tail -n 10 logs/error.log || true
                '''
            }
        }
    }
}

