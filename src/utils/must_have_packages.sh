#!/usr/bin/env bash

# https://www.willianantunes.com/blog/2021/05/production-ready-shell-startup-scripts-the-set-builtin/
set -eux -o pipefail

source "${BASH_SOURCE%/*}/helpers.sh"

echo "<<<<<< Add Git Core repository"
sudo add-apt-repository --no-update -y ppa:git-core/ppa

"${APT_GET[@]}" update

echo "<<<<<< General packages"
"${APT_GET_INSTALL[@]}" git \
  curl \
  vim \
  gnome-shell-extensions \
  gnome-disk-utility \
  bash-completion \
  fonts-powerline \
  linux-generic \
  build-essential \
  dkms \
  jq \
  nmap \
  net-tools \
  putty \
  httpie \
  peek \
  apt-transport-https \
  ca-certificates \
  gnupg \
  lm-sensors \
  psensor \
  hddtemp

echo "<<<<<< Add GCP Cloud SDK distribution URI"
echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "<<<<<< Add Azure CLI software repository"
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

echo "<<<<<< Add OpenVPN repository"
wget -qO - https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub | sudo apt-key add -
sudo wget -O /etc/apt/sources.list.d/openvpn3.list https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-focal.list

# As we added new repositories...
"${APT_GET[@]}" update

echo "<<<<<< Install Google Chrome"
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
"${APT_GET_INSTALL[@]}" ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

echo "<<<<<< Install Docker"
"${CURL[@]}" https://get.docker.com | sudo -E sh -
sudo usermod -aG docker vagrant

echo "<<<<<< Install Docker Compose"
version=$("${CURL[@]}" https://api.github.com/repos/docker/compose/releases/latest | jq .tag_name -er)
sudo "${CURL[@]}" -o /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/${version}/docker-compose-$(uname -s)-$(uname -m)"
sudo chmod +x /usr/local/bin/docker-compose

echo "<<<<<< Install kubectl"
# sudo "${CURL[@]}" -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
sudo "${CURL[@]}" -o kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

echo "<<<<<< Install k9s"
# https://k9scli.io/topics/commands/
version=$("${CURL[@]}" https://api.github.com/repos/derailed/k9s/releases/latest | jq .tag_name -er)
"${CURL[@]}" "https://github.com/derailed/k9s/releases/download/${version}/k9s_Linux_amd64.tar.gz" | tar xz
sudo install -o root -g root -m 0755 k9s /usr/local/bin/k9s
rm LICENSE README.md k9s

echo "<<<<<< Install Krew"
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

echo "<<<<<< Install KinD"
version=$("${CURL[@]}" https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | jq .tag_name -er)
sudo "${CURL[@]}" -o /usr/local/bin/kind "https://github.com/kubernetes-sigs/kind/releases/download/${version}/kind-$(uname -s)-amd64"
sudo chmod +x /usr/local/bin/kind

echo "<<<<<< Install Helm 3"
"${CURL[@]}" https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sudo -E bash -

echo "<<<<<< Install ngrok"
"${CURL[@]}" -o ngrok.tgz "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"
tar xvzf ngrok.tgz
sudo install -o root -g root -m 0755 ngrok /usr/local/bin/ngrok
rm ngrok

echo "<<<<<< Install AWS CLI and AWS IAM Authenticator"
sudo "${CURL[@]}" -o "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws*
sudo "${CURL[@]}" -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
sudo chmod +x /usr/local/bin/aws-iam-authenticator

echo "<<<<<< Install GCP CLI"
# https://github.com/kubernetes/release/issues/1982
"${APT_GET_INSTALL[@]}" google-cloud-sdk

echo "<<<<<< Install Azure CLI"
"${APT_GET_INSTALL[@]}" azure-cli

echo "<<<<<< Install OpenVPN"
"${APT_GET_INSTALL[@]}" openvpn3

echo "<<<<<< Install Steampipe CLI"
# https://steampipe.io/docs
"${CURL[@]}" "https://github.com/turbot/steampipe/releases/download/v0.13.1/steampipe_$(uname -s)_amd64.tar.gz" | tar xz
sudo install -o root -g root -m 0755 steampipe /usr/local/bin/steampipe
rm steampipe

echo "<<<<<< Install Auth0 CLI"
# "Auth0 CLI is the command line to supercharge your development workflow"
auth0_cli_version=$("${CURL[@]}" https://api.github.com/repos/auth0/auth0-cli/releases/latest | jq .tag_name -er)
auth0_cli_version_without_v=$(cut -c2- <<< $auth0_cli_version)
"${CURL[@]}" "https://github.com/auth0/auth0-cli/releases/download/${auth0_cli_version}/auth0-cli_${auth0_cli_version_without_v}_Linux_x86_64.tar.gz" | tar xz
sudo install -o root -g root -m 0755 auth0 /usr/local/bin/auth0
rm auth0

echo "<<<<<< Install Akamai CLI"
akamai_cli_version=$("${CURL[@]}" https://api.github.com/repos/akamai/cli/releases/latest | jq .tag_name -er)
sudo "${CURL[@]}" -o /usr/local/bin/akamai "https://github.com/akamai/cli/releases/download/${akamai_cli_version}/akamai-${akamai_cli_version}-linuxamd64"
sudo chmod +x /usr/local/bin/akamai

echo "<<<<<< Install Terragrunt"
terragrunt_version=$("${CURL[@]}" https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | jq .tag_name -er)
"${CURL[@]}" -o terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/${terragrunt_version}/terragrunt_linux_amd64"
chmod u+x terragrunt
install terragrunt ~/.local/bin

echo "<<<<<< Install cert-manager command line tool"
cmctl_version=$("${CURL[@]}" https://api.github.com/repos/cert-manager/cert-manager/releases/latest | jq .tag_name -er)
"${CURL[@]}" "https://github.com/cert-manager/cert-manager/releases/download/${cmctl_version}/cmctl-linux-amd64.tar.gz" | tar xz
install cmctl ~/.local/bin
rm LICENSE cmctl
