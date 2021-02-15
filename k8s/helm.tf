resource "helm_release" "nfsp-client-provisioner" {
  name = "nfs-client-provisioner"
  chart = "stable/nfs-client-provisioner"
  repository = "charts.helm.sh/stable"

  set {
    name = "nfs.server"
    value = "192.168.1.230"
  }
  set {
    name = "nfs.path"
    value = "/data/export"
  }
  set {
    name = "image.repository"
    value = "quay.io/external_storage/nfs-client-provisioner-arm"
  }
}
