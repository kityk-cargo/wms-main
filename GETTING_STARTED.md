# Getting Started

## 1. Set up database using Liquibase

- Navigate to `wms-main/liquibase/scripts`
- Create an environment file based on the template (note: `.env.example` was not found, check if there's another example file or contact the team)
- Run the database setup using:
  - For Windows: `liquibase.bat`
  - For Unix/Linux: `./update.sh`
  - Or use another Liquibase method of your choice
  - Use the `test` option if you want to include initial test data

## 2. Deploy the main chart (prerequisites: Kubernetes and Helm)

- Navigate to `wms-main/helm`
- Copy `values-local-example.yaml` to create your own `values-local.yaml` if you don't have one
- Update `values-local.yaml` with necessary credentials (username/password)
  - Note: Storing credentials in values files is temporary and should be moved to secrets
- Run the following command:
  ```
  helm upgrade --install wms-main . -f values-local.yaml
  ```

## 3. Deploy the APISIX gateway chart

- Navigate to `wms-gateway/helm`
- Run the following command:
  ```
  helm install wms-gateway . -f values.yaml -f values-local.yaml
  ```

---

**Note:** Currently, only local deployment has been tested. However, the values can be easily tailored to remote environments if needed.