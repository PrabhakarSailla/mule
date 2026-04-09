# CI/CD Pipeline Setup for MuleSoft Anypoint Platform

This repository includes a complete CI/CD pipeline for automatically deploying your MuleSoft application to Anypoint Platform using GitHub Actions and CloudHub 2.0.

## Pipeline Overview

The CI/CD pipeline consists of three main stages:
1. **Build** - Compile, test, and package the application
2. **Deploy to Development** - Automatic deployment to dev environment on master/main branch
3. **Notify** - Report deployment status

## Prerequisites

Before setting up the pipeline, ensure you have:
- GitHub repository with your MuleSoft application
- Anypoint Platform account with appropriate permissions
- Access to CloudHub 2.0 or Runtime Fabric environments

## GitHub Secrets Configuration

You need to configure the following secrets in your GitHub repository:

### Go to: Repository Settings → Secrets and Variables → Actions

#### Required Secrets:
- `ANYPOINT_USERNAME` - Your Anypoint Platform username
- `ANYPOINT_PASSWORD` - Your Anypoint Platform password
- `BUSINESS_GROUP` - Your Anypoint organization/business group ID
- `DEV_ENVIRONMENT` - Development environment name (e.g., "Development")
- `PROD_ENVIRONMENT` - Production environment name (e.g., "Production")

#### Optional Variables:
- `MULE_VERSION` - Mule runtime version (default: 4.4.0)

## Environment Setup

### 1. Create GitHub Environments

Go to Repository Settings → Environments and create:
- **development** environment
- **production** environment

### 2. Configure Environment Protection Rules

For production environment, consider adding:
- Required reviewers
- Wait timer
- Deployment branches (restrict to main/master)

## Pipeline Configuration

### Deployment Parameters

The pipeline uses the following default configurations:

| Environment | Workers | Worker Type | Application Name |
|------------|---------|-------------|------------------|
| Development | 1 | MICRO | hello-world-mule-dev |
| Production | 2 | MICRO | hello-world-mule-prod |

### Customizing Deployment

You can customize deployment parameters by:

1. **Modifying the workflow file** (`.github/workflows/cicd-pipeline.yml`)
2. **Using deployment.properties** for default values
3. **Setting GitHub variables** for dynamic configuration

## Manual Deployment

You can also deploy manually using Maven:

```bash
# Deploy to Development
mvn clean deploy -DmuleDeploy \
  -Danypoint.username="your-username" \
  -Danypoint.password="your-password" \
  -Danypoint.environment="Development" \
  -Danypoint.businessGroup="your-business-group" \
  -Dapplication.name="hello-world-mule-dev" \
  -Dmule.version="4.4.0" \
  -Dworkers="1" \
  -DworkerType="MICRO"

# Deploy to Production
mvn clean deploy -DmuleDeploy \
  -Danypoint.username="your-username" \
  -Danypoint.password="your-password" \
  -Danypoint.environment="Production" \
  -Danypoint.businessGroup="your-business-group" \
  -Dapplication.name="hello-world-mule-prod" \
  -Dmule.version="4.4.0" \
  -Dworkers="2" \
  -DworkerType="MICRO"
```

## Pipeline Triggers

The pipeline automatically runs on:
- **Push** to master or main branch → Full pipeline (build + deploy)
- **Pull Request** to master or main branch → Build and test only
- **Manual trigger** → Available from GitHub Actions tab

## Monitoring and Troubleshooting

### View Pipeline Status
1. Go to your repository → Actions tab
2. Click on the workflow run to see details
3. Review logs for each job/step

### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| Authentication Failed | Verify ANYPOINT_USERNAME and ANYPOINT_PASSWORD secrets |
| Environment Not Found | Check DEV_ENVIRONMENT and PROD_ENVIRONMENT values |
| Application Already Exists | The pipeline will update existing applications |
| Insufficient Permissions | Ensure user has CloudHub deployment permissions |

### Log Monitoring
After deployment, monitor your application:
1. Login to Anypoint Platform
2. Go to Runtime Manager
3. Select your application
4. View logs and metrics

## Security Best Practices

1. **Never commit credentials** to your repository
2. **Use GitHub secrets** for all sensitive information
3. **Limit repository access** to authorized team members
4. **Enable branch protection** rules for main/master
5. **Use environment protection** rules for production deployments

## Advanced Configuration

### Using Runtime Fabric

To deploy to Runtime Fabric instead of CloudHub 2.0, modify the deployment configuration in `pom.xml`:

```xml
<runtimeFabricDeployment>
    <uri>https://anypoint.mulesoft.com</uri>
    <muleVersion>${mule.version}</muleVersion>
    <username>${anypoint.username}</username>
    <password>${anypoint.password}</password>
    <applicationName>${application.name}</applicationName>
    <environment>${anypoint.environment}</environment>
    <businessGroup>${anypoint.businessGroup}</businessGroup>
    <target>${runtime.fabric.target}</target>
    <replicas>${replicas}</replicas>
    <cpuReserved>${cpu.reserved}</cpuReserved>
    <memoryReserved>${memory.reserved}</memoryReserved>
</runtimeFabricDeployment>
```

### Custom Properties

Add custom properties to your deployment:

```xml
<properties>
    <http.port>8081</http.port>
    <secure.key>${secure.key}</secure.key>
    <database.host>${database.host}</database.host>
</properties>
```

## Support

For issues related to:
- **GitHub Actions**: Check GitHub Actions documentation
- **MuleSoft Deployment**: Check MuleSoft Maven Plugin documentation
- **Anypoint Platform**: Contact MuleSoft support

## File Structure

```
.
├── .github/
│   └── workflows/
│       └── cicd-pipeline.yml    # GitHub Actions workflow
├── src/                         # MuleSoft application source
├── pom.xml                     # Maven configuration with deployment
├── deployment.properties       # Deployment defaults
└── README-CICD.md             # This documentation