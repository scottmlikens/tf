module "k3s" {
  source  = "xunleii/k3s/module"
  # git::https://github.com/damm/terraform-module-k3s.git?ref=disable_experminetal_validation"

  k3s_version = "v1.20.2+k3s1"

  name = "likens.k3s.local"
  cidr = {
    pods = "10.0.0.0/16"
    services = "10.1.0.0/16"
  }
  drain_timeout = "30s"
#  managed_fields = ["label", "taint"]
  servers = {
    # The node name will be automatically provided by
    # the module using the field name... any usage of
    # --node-name in additional_flags will be ignored
    harar = {
      ip = "192.168.1.231" // internal node IP
      connection = {
        host = "192.168.1.231" // public node IP
        user = "root"
      }
      flags = ["--disable=traefik","--disable=metrics-server","--disable=local-storage"]
#      labels = {"node.kubernetes.io/type" = "master"}
#      taints = {"node.k3s.io/type" = "server:NoSchedule"}
    }
  }
  agents = {
    # The node name will be automatically provided by
    # the module using the field name... any usage of
    # --node-name in additional_flags will be ignored
    gondar = {
      ip = "192.168.1.232"
      connection = {
        user = "root"
      }
      
#      labels = {"node.kubernetes.io/pool" = "service-pool"}
    },
    ziway = {
      ip = "192.168.1.233"
      connection = {
        user = "root"
      }
      
      
#      labels = {"node.kubernetes.io/pool" = "service-pool"}
    },
  }
}
