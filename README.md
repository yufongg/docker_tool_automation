# Prerequisites:
1. Add user to docker group              
2. Change file permission to make it executable

# Tools used:
1. Dockle
2. Trivy
3. Snyk monitor

# What it does:
1. It automatically installs the 3 tools and run scan on local or pull image from dockerhub
2. The output from trivy & dockle is automatically converted into a HTML format for easy viewing
3. Snyk also does a scan and imports the project to your snyk account

# Credits:
- Yufong
- Raphael
