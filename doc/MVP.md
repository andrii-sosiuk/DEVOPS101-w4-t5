## DevOps та Kubernetes. Практичний інтенсив
Week 4, Practical task
.
### Description
The demonstration showcases a project from Week 1, which highlights a simple application alongside a custom-written HTTP server and HTML page that showcases the drawing process for SVG files.

In the second iteration of the project, the HTTP server was developed in Python and enhanced to identify the client making the request. It then sends the content converted from SVG to ASCII text to curl clients. For standard browsers, the content (SVG files) is displayed as originally intended.

The modifications encompass the include additional SVG file, enhancement of the HTTP server, development of a converter from SVG to ASCII, and updates to the Kubernetes deployment files.

### Demonstration of Results

For this demonstration, we utilized Argo CD to enhance our deployment processes. 

#### Environment Setup
- A developer's laptop equipped with Windows and a WSL (Windows Subsystem for Linux) Ubuntu instance. 
- A Kubernetes cluster managed through Minikube on the Ubuntu instance.
- The Argo CD service, deployed within the Minikube cluster, acting as our Continuous Deployment engine.
- The application deployed on same Kubernetes cluster on diffetent namespace

Using Argo CD has significantly simplified the deployment of changes to the Kubernetes cluster, showcasing its efficiency and ease of use in our project workflow. As shown on the next demo:

![file](.data/argocd.gif)
