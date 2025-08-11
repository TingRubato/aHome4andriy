## AWS Amplify React+Vite Starter Template

This repository provides a starter template for creating applications using React+Vite and AWS Amplify, emphasizing easy setup for authentication, API, and database capabilities.

## Overview

This template equips you with a foundational React application integrated with AWS Amplify, streamlined for scalability and performance. It is ideal for developers looking to jumpstart their project with pre-configured AWS services like Cognito, AppSync, and DynamoDB.

## Features

- **Authentication**: Setup with Amazon Cognito for secure user authentication.
- **API**: Ready-to-use GraphQL endpoint with AWS AppSync.
- **Database**: Real-time database powered by Amazon DynamoDB.

## Deploying to AWS

For detailed instructions on deploying your application, refer to the [deployment section](https://docs.amplify.aws/react/start/quickstart/#deploy-a-fullstack-app-to-aws) of our documentation.

### Quick Deploy Scripts (Gen 2)

An Amplify app (appId: `d1ntn929km6rwk`) has been created. Added npm scripts for streamlined deployment.

Authenticate first (SSO example):
```
aws sso login --profile ByteCarnival
```

Backend + frontend build combined:
```
AWS_APP_ID=d1ntn929km6rwk AWS_BRANCH=main npm run deploy
```

Backend only:
```
AWS_APP_ID=d1ntn929km6rwk AWS_BRANCH=main npm run deploy:backend
```

Frontend build only:
```
npm run build
```

Helper shell script (supports flags `-b` branch, `-a` appId, `-r` region, `-p` profile):
```
chmod +x scripts/deploy.sh
./scripts/deploy.sh -b main -a d1ntn929km6rwk -r us-east-1 -p ByteCarnival
```

These commands call `ampx pipeline-deploy` (backend) and then `vite build` (frontend). Adjust `AWS_APP_ID` and `AWS_BRANCH` if you clone into a different Amplify app/environment.

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.