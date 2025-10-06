# pos-tech-terraform

## Visão Geral

Este repositório contém a infraestrutura como código para o projeto **Fast Food Tech Challenge** da FIAP, utilizando Terraform para provisionamento de recursos na AWS. O objetivo é automatizar a criação de ambientes de nuvem, redes, segurança, Kubernetes (EKS), armazenamento e CI/CD.

---

## Referência: [Pós Tech em Software Architecture - FIAP+Alura](https://postech.fiap.com.br/curso/software-architecture/)

## Participantes

[![philipphahmann](https://github.com/philipphahmann.png?size=100)](https://github.com/philipphahmann)
[![shandersonvieira](https://github.com/shandersonvieira.png?size=100)](https://github.com/shandersonvieira)
[![vinicius-ma](https://github.com/vinicius-ma.png?size=100)](https://github.com/vinicius-ma)
[![gabrieldasilvadev](https://github.com/gabrieldasilvadev.png?size=100)](https://github.com/gabrieldasilvadev)

- Nome: Bruno César Vicente da Silva Paula | RM360941 | Email: brunocesar.oc96@gmail.com

- Nome: Philipp Teles Fernandes Erwin Hahmann | RM360012 | Email: hahmann96@gmail.com

- Nome: Shanderson da Silva Vieira | RM362970 | Email: shanderson09@gmail.com

- Nome: Vinicius Moraes Andreghetti | RM364516 | Email: vinicius.andreghetti@gmail.com

- Nome: Gabriel da Silva | RM362894 | Email: gabrieldasilvaprivado1@gmail.com

---

## Estrutura dos Arquivos e Explicação

- **backend.tf**
  Configura o backend remoto do Terraform, armazenando o estado em um bucket S3.

  - Mantém o estado compartilhado e seguro para equipes.

- **bucket.tf**
  Define controles de propriedade e bloqueio de acesso público para o bucket S3 utilizado como backend do Terraform.

- **eks-cluster.tf**
  Provisiona o cluster EKS (Elastic Kubernetes Service) na AWS, especificando subnets, security group e modo de autenticação.

- **eks-data.tf**
  Utiliza data sources para buscar informações de recursos existentes, como VPC, subnets, cluster EKS e autenticação.

- **eks-node.tf**
  Cria um Node Group para o EKS, definindo instâncias EC2 que compõem os nós do cluster, tipo de instância, subnets e escalabilidade.

- **iam-access-entry.tf**
  Cria uma entrada de acesso ao EKS para um principal (usuário/role IAM), associando grupos Kubernetes.

- **iam-access-policy.tf**
  Associa uma policy de acesso ao cluster EKS para o principal definido, permitindo administração do cluster.

- **k8s-ecr.tf**
  Provisiona um repositório ECR (Elastic Container Registry) para armazenar imagens Docker utilizadas no cluster.

- **networking-internet-g.tf**
  Cria um Internet Gateway para permitir acesso à internet a partir da VPC.

- **networking-sg.tf**
  Define um Security Group para controlar o tráfego de entrada (porta 80) e saída (todas as portas) do cluster e serviços.

- **networking-subnet.tf**
  Cria três subnets públicas em diferentes zonas de disponibilidade, permitindo alta disponibilidade dos recursos.

- **networking-vpc.tf**
  Cria a VPC principal do projeto, habilitando DNS e suporte a hostnames.

- **outputs.tf**
  Exporta a URL do repositório ECR criado, útil para integração com pipelines de CI/CD.

- **providers.tf**
  Define os providers necessários: AWS, Kubernetes e Kubectl, além de suas versões e configurações.

- **variables.tf**
  Centraliza todas as variáveis do projeto, como região, nomes, ARNs, tipos de instância, tags, CIDR da VPC, etc.

---

## Fluxo de Provisionamento

1. **Rede**: Criação da VPC, subnets públicas, Internet Gateway, tabela de rotas e security group.
2. **Cluster EKS**: Provisionamento do cluster, node group e permissões IAM.
3. **Repositório ECR**: Criação do repositório para imagens Docker.
4. **Controle de acesso**: IAM roles, policies e entradas de acesso ao cluster.
5. **Backend remoto**: Configuração do bucket S3 para armazenar o estado do Terraform.

---

## Integração e Automação com GitHub Actions

O projeto utiliza pipelines de CI/CD com GitHub Actions para garantir automação, padronização e segurança no ciclo de vida da infraestrutura:

- **.github/workflows/terraform-plan.yml**
  Executa o `terraform plan` a cada push ou execução manual, validando e mostrando as mudanças que serão aplicadas na infraestrutura.

- **.github/workflows/terraform-apply.yml**
  Permite aplicar (`terraform apply`) as mudanças na infraestrutura de forma automatizada e controlada via execução manual (workflow_dispatch).

- **.github/workflows/terraform-destroy.yml**
  Permite destruir (`terraform destroy`) toda a infraestrutura provisionada, também via execução manual.

**Principais etapas dos workflows:**

- Checkout do código do repositório.
- Configuração das credenciais AWS via secrets do GitHub.
- Instalação da versão especificada do Terraform.
- Execução dos comandos Terraform (`init`, `validate`, `plan`, `apply` ou `destroy`).

> **Importante:**
> As credenciais AWS são fornecidas de forma segura via GitHub Secrets.
> O uso dos workflows `apply` e `destroy` é manual para evitar alterações/destruições acidentais.

---

## Pré-requisitos

- [Terraform >= 1.5.0](https://www.terraform.io/downloads.html)
- Conta AWS com permissões adequadas
- Configuração das credenciais AWS (`aws configure` ou variáveis de ambiente)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) instalado para interagir com o cluster EKS

---

## Como Usar

1. **Clone o repositório**

   ```bash
   git clone https://github.com/seu-usuario/pos-tech-terraform.git
   cd pos-tech-terraform
   ```

2. **Configure as variáveis necessárias**

   - Edite o arquivo `variables.tf` conforme seu ambiente.

3. **Inicialize o Terraform**

   ```bash
   terraform init
   ```

4. **Visualize o plano de execução**

   ```bash
   terraform plan
   ```

5. **Aplique a infraestrutura**

   ```bash
   terraform apply
   ```

6. **Destrua a infraestrutura (quando necessário)**
   ```bash
   terraform destroy
   ```

---

## Observações

- Revise as variáveis antes de aplicar.
- Utilize workspaces para ambientes diferentes (ex: dev, staging, prod).
- O estado do Terraform é armazenado remotamente no S3 para colaboração e segurança.
- Consulte os arquivos `.tf` para detalhes e customizações.

---

## Licença

Este projeto é de uso acadêmico e segue as diretrizes da FIAP.
