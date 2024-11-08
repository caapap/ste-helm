# Helm Chart for stellar

中文 | [English](README.md)


## 前置依赖

- Kubernetes cluster 1.20+
- Helm v3.2.0+

##  安装

### 获取 repo

```bash
git clone https://github.com/caapap/stellar-helm.git```

### 配置chart
以下配置项可以在安装时通过 `--set`传入 或者 直接编辑 `values.yaml` 

#### 配置暴露星相服务的方式

- **Ingress**: k8s集群中必须已经安装了ingress controller
- **ClusterIP**: 通过集群的内部 cluster ip 暴露服务，选择该值时服务只能够在集群内部访问。
- **NodePort**: 通过每个节点上的 IP 和静态端口（NodePort）暴露服务。在集群外通过`NodeIP:NodePort` 访问星相服务。
- **LoadBalancer**: 使用云提供商的负载均衡器向外部暴露服务。

#### 配置星相服务使用TLS

- **enabled**: 是否使用tls方式。如果`expose.type` 为 `ingress` 并且 `enabled`为`false`时，记得删除expose.ingress.annotations中的ssl-redirect annotations。
- **certSource**: TLS证书来源。 可选项为`auto`, `secret`, `none`。
    - auto: 自动生成TLS证书。
        - commonName: 用于生成证书的CN, 如果`expose.type` 不是 `ingress`, 此项必须填写。
    - secret: 从特定的secret中读取证书信息。TLS证书可以手动生成，或通过cert manager生成。
        - secretName: secret的名字，必须包含以下两个key的内容
            - tls.crt: 证书内容
            - tls.key: 私钥内容
    - none: 不使用TLS证书(ingress模式)。 **如果** ingress controller配置了默认的TLS证书, 使用此选项。

#### 配置external URL

external URL主要用于访问星相web服务

格式: `protocol://domain[:port]`。 通常:

- 如果通过 `Ingress` 暴露服务, `domain` 应该配置为 `expose.ingress.hosts.web`
- 如果通过 `ClusterIP` 暴露服务, `domain` 应该配置为 `expose.clusterIP.name`
- 如果通过 `NodePort` 暴露服务, `domain` 应该配置为 k8s 集群内node的IP 
- 如果通过 `LoadBalancer` 暴露服务, `domain` 应该配置为从云提供商那里获取到的域名的CNAME(自有域名作为提供商域名的cname)

> 注意:

1. 如果星相部署在proxy之后，那 `domain` 设置为proxy的URL
2. 星相web服务的初始用户名为 `root`，初始密码为 `root.2020`

#### 配置持久化存储

- **Disable**: 关闭持久存储，pod生命周期结束后，数据消失。
- **Persistent Volume Claim(default)**:  需要设置`StorageClass`以便k8s提供动态卷支持。 如果已有持久卷, 就配置到 `existingClaim`


### 安装chart

使用 `stellar` 名称进行安装:
```bash
helm install stellar ./stellar-helm -n kxdigit-monitoring --create-namespace
```

## 卸载

卸载/删除 `stellar`:
```
helm uninstall  stellar -n stellar
```
