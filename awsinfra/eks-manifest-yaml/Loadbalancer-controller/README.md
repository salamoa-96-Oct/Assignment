# AWS LoadBalacner Controller 설치 방법


## Documentation

[AWS LoadBalancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/) 가이드 문서

## 설치방법

 1. **AWS LoadBalancer 생성에 필요한 IAM 역할 생성 (Serviceaccount)**
    ```
    curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

    aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy-[name] \
    --policy-document file://iam-policy.json
    ```

 2. **serviceaccount 생성**
    ```
    eksctl create iamserviceaccount \
    --cluster=<cluster-name> \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::<AWS_ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy-[name] \
    --override-existing-serviceaccounts \
    --region <region-code> \
    --approve
    ```

 3. **cert-manager 설치**
    ```
    kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
    ```

 4. **LBC 설치**
    ```
    wget https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_full.yaml
    
    % 주의 %    
    위에서 serviceaccount에 iam 역할을 할당하여 deployment에서 serviceaccount 생성하는 부분 삭제 후 apply
    deployment에서 args 설정

    spec:
      containers:
      - args:
        - --cluster-name=[cluster-name]
        - --ingress-class=alb
        - --aws-vpc-id=[VPC-name]
        - --aws-region=ap-northeast-2
        - --aws-max-retries=10
    
    kubectl apply -f v2_5_4_full.yaml
    ```
