# Configure Ansible:

Get Azuer Dynamic Inventory Script
```bash
git clone https://github.com/ansible/ansible/blob/stable-2.9/lib/ansible/plugins/inventory/azure_rm.py
```
Create a Service Principal for Ansible
```bash
nenad@Azure:~$ az ad sp create-for-rbac --name svc-ansible-azur
Changing "svc-ansible-azur" to a valid URI of "http://svc-ansible-azur", which is the required format used for service principal names
Creating a role assignment under the scope of "/subscriptions/65b39c88-21ee-4efa-b52c-fc8151f2a75d"
{
  "appId": "91f6c1fc-4e58-4e20-a6d1-ba948b380372",
  "displayName": "svc-ansible-azur",
  "name": "http://svc-ansible-azur",
  "password": "j6c9R3-_bux7ZkLOPOzW4z6aj1EA~3ZAm9",
  "tenant": "97798909-f929-4d83-9cb8-3c4760d67488"
}

nenad@Azure:~$ az account show
{
  "environmentName": "AzureCloud",
  "homeTenantId": "97798909-f929-4d83-9cb8-3c4760d67488",
  "id": "65b39c88-21ee-4efa-b52c-fc8151f2a75d",
  "isDefault": true,
  "managedByTenants": [],
  "name": "Azure subscription 1",
  "state": "Enabled",
  "tenantId": "97798909-f929-4d83-9cb8-3c4760d67488",
  "user": {
    "name": "nenadmiladin@yahoo.com",
    "type": "user"
  }
}
```
Create credentials file:
```bash
touch $HOME/.azure/credentials
```
Populate credentials:

id==AZURE_SUBSCRITION_ID

tenantId==AZURE_TENANT

appId==AZURE_CLIENT_ID

password==AZURE_SECRET

```bash
nenad@Azure:~$ cat .azure/credentials
[default]
subscription_id=65b39c88-21ee-4efa-b52c-fc8151f2a75d
client_id=91f6c1fc-4e58-4e20-a6d1-ba948b380372
secret=j6c9R3-_bux7ZkLOPOzW4z6aj1EA~3ZAm9
tenant=97798909-f929-4d83-9cb8-3c4760d67488
cloud_environment=AzureCloud
```
```bash
Test:

ansible all -m ping -i azure_rm.py
```

## Create Jenkins Slave

ansible-playbook -i azure_rm.py Jenkins-Slave.yaml
