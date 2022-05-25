pipeline:
    name: ${name}
    identifier: ${identifier}
    projectIdentifier: ${project_identifier}
    orgIdentifier: ${org_identifier}
    tags: {}
    stages:
        - stage:
              name: server
              identifier: server
              description: ""
              type: Deployment
              spec:
                  serviceConfig:
                      serviceRef: ${server_service_id}
                      serviceDefinition:
                          spec:
                              variables: []
                              manifests:
                                  - manifest:
                                        identifier: serverValues
                                        type: Values
                                        spec:
                                            store:
                                                type: Github
                                                spec:
                                                    connectorRef: ${github_connector_id}
                                                    gitFetchType: Branch
                                                    paths:
                                                        - ${server_manifest_values_path}
                                                    branch: ${branch}
                                  - manifest:
                                        identifier: serverManifest
                                        type: K8sManifest
                                        spec:
                                            store:
                                                type: Github
                                                spec:
                                                    connectorRef: ${github_connector_id}
                                                    gitFetchType: Branch
                                                    paths:
                                                        - ${server_manifest_path}
                                                    branch: ${branch}
                                            skipResourceVersioning: false
                          type: Kubernetes
                  infrastructure:
                      environmentRef: ${environment_id}
                      infrastructureDefinition:
                          type: KubernetesDirect
                          spec:
                              connectorRef: ${kubernetes_connector_id}
                              namespace: ${kubernetes_namespace}
                              releaseName: release-<+INFRA_KEY>
                      allowSimultaneousDeployments: false
                  execution:
                      steps:
                          - step:
                                name: Rollout Deployment
                                identifier: rolloutDeployment
                                type: K8sRollingDeploy
                                timeout: 10m
                                spec:
                                    skipDryRun: false
                      rollbackSteps:
                          - step:
                                name: Rollback Rollout Deployment
                                identifier: rollbackRolloutDeployment
                                type: K8sRollingRollback
                                timeout: 10m
                                spec: {}
              tags: {}
              failureStrategies:
                  - onFailure:
                        errors:
                            - AllErrors
                        action:
                            type: StageRollback
        - stage:
              name: client
              identifier: client
              description: ""
              type: Deployment
              spec:
                  serviceConfig:
                      serviceRef: ${client_service_id}
                      serviceDefinition:
                          spec:
                              variables: []
                              manifests:
                                  - manifest:
                                        identifier: clientManifest
                                        type: K8sManifest
                                        spec:
                                            store:
                                                type: Github
                                                spec:
                                                    connectorRef: ${github_connector_id}
                                                    gitFetchType: Branch
                                                    paths:
                                                        - ${client_manifest_path}
                                                    branch: ${branch}
                                            skipResourceVersioning: false
                          type: Kubernetes
                  infrastructure:
                      environmentRef: ${environment_id}
                      infrastructureDefinition:
                          type: KubernetesDirect
                          spec:
                              connectorRef: ${kubernetes_connector_id}
                              namespace: ${kubernetes_namespace}
                              releaseName: release-<+INFRA_KEY>
                      allowSimultaneousDeployments: false
                  execution:
                      steps:
                          - step:
                                name: Rollout Deployment
                                identifier: rolloutDeployment
                                type: K8sRollingDeploy
                                timeout: 10m
                                spec:
                                    skipDryRun: false
                      rollbackSteps:
                          - step:
                                name: Rollback Rollout Deployment
                                identifier: rollbackRolloutDeployment
                                type: K8sRollingRollback
                                timeout: 10m
                                spec: {}
              tags: {}
              failureStrategies:
                  - onFailure:
                        errors:
                            - AllErrors
                        action:
                            type: StageRollback

