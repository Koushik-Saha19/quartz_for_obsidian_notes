
### **Rolling Update:**
-----------------------------
**`kubectl rollout restart deploy` (Rolling Update):**

**How it works:** 
When you run this command (or when you update an image tag in a Deployment and apply it), Kubernetes starts creating **new Pods (with the updated version) one by one**, while simultaneously **terminating old Pods one by one**.

**Traffic Flow:** 
Traffic gradually shifts from old Pods to new Pods as they become ready. There's an overlap period where both old and new versions of Pods are running and serving traffic.

**Goal:** 
To achieve zero-downtime updates by ensuring that a minimum number of Pods are always available to serve traffic.

**Rollback:** 
If issues arise, Kubernetes can roll back to a previous revision, but this also happens as a rolling update, not an instantaneous switch.


### **Blue-Green deployment:**
--------------------------------------------------
Blue - old deployment or pods
Green - New deployment or pods.

When we want to deploy a new image tag by updating the deployment - 
Here rule is, the old pods will continue to server the traffics until the new pod is fully up & running.
 
**Blue-Green Deployment:**

- **How it works:** As discussed, you deploy the new version to a **completely separate set of Pods (the "Green" environment)**. The old version ("Blue") continues to serve all traffic. Only after the Green environment is fully ready and tested is **all traffic instantly switched** from Blue to Green.
- **Traffic Flow:** An "all or nothing" switch from one fully stable environment to another fully stable environment. There's no gradual shifting of traffic or mixing of old/new versions _at the production traffic level_.
- **Goal:** Zero-downtime deployment with a fast, reliable rollback mechanism (just switch back to Blue).

### **Canary Deployment**
-------------------------------
In Kubernetes, **Canary deployment** is a strategy where you deploy a new version of your application (the "canary") to a **small subset of Pods** alongside your current production version.

Traffic is then **gradually diverted to these canary Pods** (e.g., 5%, then 25%, then 50%) using **Service Mesh features (like Istio's traffic splitting)** or advanced **Ingress controller rules**. You monitor the canary's performance and stability closely. If healthy, you incrementally shift more traffic; if issues arise, you quickly revert the traffic split to the old version, limiting impact to a small user group.


### Restarting Deployment
---------------
- kubectl scale deploy test-deploy -n my-ns --replicas=0
- kubectl scale deploy test-deploy -n my-ns --replicas=1

It's often used as a quick way to force a full "restart" of an application if the Deployment's rolling update strategy isn't behaving as expected (in non-production environments where downtime is acceptable. It is **not** a method for zero-downtime deployments like Blue-Green or Rolling Updates.



