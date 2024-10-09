eksctl create cluster --name project1 --region us-east-1 --nodegroup-name standard-workers --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4 --managed

###Configure Amazon EBS CSI driver for working PersistentVolumes in EKS
eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=project1 --approve
eksctl create iamserviceaccount \
  --region us-east-1 \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster project1 \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name AmazonEKS_EBS_CSI_DriverRole

aws sts get-caller-identity --query Account --output text
eksctl create addon --name aws-ebs-csi-driver --cluster project1 --service-account-role-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/AmazonEKS_EBS_CSI_DriverRole --force
###end

helm install rabbitmq oci://registry-1.docker.io/bitnamicharts/rabbitmq  --set  persistence.storageClass=gp2

Credentials:
    echo "Username      : user"
    echo "Password      : $(kubectl get secret --namespace default rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d)"
    echo "ErLang Cookie : $(kubectl get secret --namespace default rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)"


###add guest user
kubectl exec -it rabbitmq-0 -c rabbitmq -- /bin/bash
rabbitmqctl add_user guest guest
rabbitmqctl set_permissions -p / guest ".*" ".*" ".*"


aws eks get-token --region us-east-1 --cluster-name project1


