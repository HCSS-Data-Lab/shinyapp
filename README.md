# About shinyapp   
[![Publish hcss shinyapp docker image](https://github.com/HCSS-Data-Lab/shinyapp/actions/workflows/action.yml/badge.svg?branch=master)](https://github.com/HCSS-Data-Lab/shinyapp/actions/workflows/action.yml)  

HCSS shinyapp container definition.  
Container used to run shinyapps hosted within shinyproxy.  

## Frameworks used
- shinyapp  

# Docker image details 
Base image: rocker/r-ubuntu:20.04  
Exposed ports: 8000  
Additional installed resources:  
- Troubleshooting: vim, net-tools, dos2unix  
