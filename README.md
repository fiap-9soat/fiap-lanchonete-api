# fiap-lanchonete-api

Configuração do Terraform para deploy da API do fiap-lanchonete.

## Ordem de execução

A maioria dos projetos nessa organização exporta e importa estados no backend compartilhado do Terraform (utilizando
HCP).
Sendo assim, no primeiro deploy, os projetos devem ser executados na seguinte ordem:

```
fiap-lanchonete-auth
fiap-lanchonete-infra
fiap-lanchonete-db
fiap-lanchonete-api
```

**Importante**: esse passo só é necessário caso você esteja "subindo" o projeto pela primeira vez,
como em uma troca de organização do HCP ou troca de conta do AWS.
Essa ordem garante que os projetos exportarão as variaveis necessárias no backend compartilhado corretamente.  
Nos demais casos (como CI/CD, execuções do `terraform apply` posteriores),
a ordem de execução não é importante.

## Instalação e Execução

### Pre-requisitos

Certifique-se de ter instalado uma versão recente da CLI do `terraform` e do `aws`.

### Autenticação no AWS CLI

É necessário autenticar-se com o `AWS` para viabilizar o deploy desse projeto.  
https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-authentication.html

### Variaveis de ambiente

É necessário criar algumas variaveis de ambiente para viabilizar a aplicação das configurações pelo CLI do Terraform.  
Para ambiente local, basta utilizar o arquivo `dev.auto.tfvars.example` como exemplo, criando um `dev.auto.tfvars`
correspondente:

```hcl
aws_access_key        = "ASIAVEZQ3WJY2KR216362"
aws_secret_key        = "TU+qlmgcNsX5MQz1238214821748211"
aws_token_key         = "123872183721857128............."
db_url = "..." # recebido APÓS a subida do RDS, altere assim que finalizar o deploy do fiap-lanchonete-db (AWS RDS).
db_username = "fiap" # correspondente ao valor especificado no fiap-lanchonete-db (AWS RDS)
db_password = "fiap-lanchonete" # correspondente ao valor especificado no fiap-lanchonete-db (AWS RDS)
mercado_pago_api_key  = "TEST-8402790990254628-112619-4290252fdac6fd07a3b8bb555578ff39-662144664"
mercado_pago_id_loja  = "1B2D92F23"
mercado_pago_id_conta = 662144664
```

_Atenção: essas credenciais são inválidas (exceto as relacionadas ao MercadoPago), e servem apenas como exemplo.
Você deve obter as credenciais corretas do próprio ambiente da AWS. Todas as variáveis são obrigatórias._

Para ambientes de teste, pode-se utilizar essas variaveis relacionadas ao MercadoPago:

```hcl
mercado_pago_api_key  = "TEST-8402790990254628-112619-4290252fdac6fd07a3b8bb555578ff39-662144664"
mercado_pago_id_loja  = "1B2D92F23"
mercado_pago_id_conta = "662144664"
```

### Após subida do RDS

A variavel `db_url` só pode ser obtida após a subida do projeto `fiap-lanchonete-db`, onde ela é exportada como
`output`.  
Portanto, é imprescindível que o projeto de banco de dados suba ANTES deste.  
Após a subida, altere o valor da variavel `db_url` para o valor correspondente, e execute o apply.

```hcl
db_url = "fiap-lanchonete-db.cgreghhtfwd5.us-east-1.rds.amazonaws.com"
```

O `endpoint` da instância do MySQL no RDS também pode ser consultado diretamente na interface do AWS.

A tabela abaixo relaciona as credenciais especificadas nas variaveis do Terraform com as presentes no arquivo
`~/.aws/credentials`.

| tfvars         | ~/.aws/credentials    |
|----------------|-----------------------|
| aws_access_key | aws_access_key_id     |
| aws_secret_key | aws_secret_access_key |
| aws_token_key  | aws_session_token     |

### Estrutura

Esse repositório faz uso da funcionalidade de `modules` do Terraform, onde um arquivo principal (`main.tf`) orquestra o
deploy
de sub-modulos (pasta `modules`), passando as variaveis necessárias.
Para realizar os comandos (`terraform apply`, etc). Apenas as variaveis presentes no arquivo `variables.tf` devem ser
preenchidas.  
Estas estão especificadas logo acima.

## Aplicar configurações

Inicialize os módulos do Terraform do repositório:

```shell
terraform init
```

Com a configuração realizada, basta executar o seguinte comando para validar a configuração e conferir as alterações
que serão realizadas:

```shell
terraform plan
```

Caso o comando execute corretamente, você está devidamente autenticado em alguma instância válida do `AWS`.  
Para aplicar as alterações, basta rodar o seguinte comando e inserir 'yes' quando solicitado:

```shell
terraform apply
```

### Após subida do RDS

É de extrema importância que você altere as variaveis relacionadas ao banco de dados **APÓS** a subida do RDS.  
_Esse passo normalmente só é necessário durante a subida inicial, exceto se as credenciais forem alteradas
manualmente._  
Altere as seguintes variaveis para os valores especificados
no [fiap-lanchonete-db](https://github.com/fiap-9soat/fiap-lanchonete-db),
em especial o `db_url`, que só é obtido após a subida da instância.

```hcl
db_url = "fiap-lanchonete-db.cgreghhtfwd5.us-east-1.rds.amazonaws.com"
```

## Erros comuns

**Importante**: Caso seja a primeira "subida" do projeto, siga a ordem de execução
especificada [aqui](#ordem-de-execução).

### Permissões

Verifique se o usuario executante tem permissões para criações de instâncias do AWS EKS, AWS EKS NodeGroups, VPC e
Subnets.

### AWS com LabRole

Devido a natureza efêmera da instância de AWS utilizada pelo AWS Instructure, pode ser que você receba erros ao executar
o
`terraform plan` ou `terraform apply` depois da primeira execução.  
Por esse motivo, recomendamos [limpar o estado local](#limpando-estado-local) do
Terraform sempre que subir uma nova instância do AWS Lab.

### Limpando estado local

Na maioria das vezes, os erros são solucionados simplesmente limpando o estado local para remover referências a
elementos
que não existem mais.  
Para isso, basta remover esses arquivos e diretórios da pasta raiz do repositório:

```
.terraform
terraform.lock.hcl
terraform.tfstate
terraform.tfstate.backup
```

E em seguida reiniciar os módulos:

```shell
terraform init
```

#### Error: Kubernetes cluster unreachable

```
╷
│ Error: Kubernetes cluster unreachable: invalid configuration: no configuration has been provided, try setting KUBERNETES_MASTER environment variable
│
│   with module.api_gateway.helm_release.aws_load_balancer_controller,
│   on modules/api_gateway/0-load-balancer.tf line 2, in resource "helm_release" "aws_load_balancer_controller":
│    2: resource "helm_release" "aws_load_balancer_controller" {
│
╵
```

Esse erro ocorre porque o Terraform tenta realizar uma conexão automatica com o cluster do Kubernetes (especificado nos
providers `helm` e `kubernetes`)  
e caso o cluster "suma" depois que o estado inicial é gerado, a conexão falha e consequentemente um erro é retornado no
`plan`.
A solução é [limpar o estado local](#limpando-estado-local) e [re-aplicar](#aplicar-configurações) a configuração.
