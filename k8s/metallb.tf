locals {
  metallb_uri = "https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml"
  metricserver_uri = "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"

}
resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"

    labels = {
      app = "metallb"
    }
  }
}
resource "null_resource"  "apply_metallb_manifests" {
  triggers = {
    uri = local.metallb_uri
  }

  provisioner "local-exec"  {
    command = "kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml"
  }
}
resource "null_resource" "metallb_secret" {
  provisioner "local-exec" {
    command = "kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey=\"$(openssl rand -base64 128)\""
  }
}
resource "kubernetes_config_map" "config" {
  metadata {
    name      = "config"
    namespace = "metallb-system"
  }

  data = {
    config = "address-pools:\n- name: default\n  protocol: layer2\n  addresses:\n  - 192.168.1.240-192.168.1.250\n"
  }
  depends_on = [kubernetes_namespace.metallb_system]
}

resource "null_resource" "apply_metricserver_yaml" {
  triggers = {
    uri = local.metricserver_uri
  }
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
  }
}
