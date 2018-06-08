# Install Fluentd container

## create login for AWS ECR
Docker container is deployed on ECR, that require authentication. In order to setup secret on ECR, this is the command to submit:

```
kubectl create secret docker-registry regcred --docker-server=https://870594606895.dkr.ecr.eu-central-1.amazonaws.com --docker-username=AWS --docker-password=eyJwYXlsb2FkIjoick5ERk9qelFIVmVrTG95cGFRR0ZQaEZqc0xnOEdGWmRtS01tcVloclJwUUxrQWNGU3lhMmNtY0RvaHhYbndkQldTdFd2Zmo0K3FWdHRacnF3QWdKRDJnTnRwcHR6QnBGdW9xNzVGS2VwajFJWGFXQmZmcS9DNlRVZWU2akQ2N3pOaTFyR0RBRjlFZmRacDNadWdnc1JMK1pqZEVCU3h4elNNek90cnc1K1EyVHIvOUIxOHZJdDJvaHkvTWVCTk1mSTlNTVRQdFRVOStOUTVWS1FZNWRyKzdnMitERHg4eDBFRTJrR1NJSWFQUU5WWDNCOWpwcVN0eTNHS1Q4Zk10TGtITHpJdmdRbFRsS0M3SFdraWtOOXZOMVFBSjZHcFZzSEpTbHRSdmpGU29rME4xK1JMMUY0Rzl6eXV3WHdTQjJqSitrbWdkSVZXMzdYZTN1cVNpdG0xeHEzREgyV1lRcS9JSEV5NURrdHlZQmFUeHVJVkk0WTgzYjBBeGRYczNhQ252anpRMUZvU3pMSmEvSkswK2cxaEltR2VPZ0ZjSEprL2cxLzdyWkU3ek1NQVhOd3FQTUozajhMTVRUaHJFTEpsZFBTY21oRFJOYWFzWVFBT01MN0ZLbS9HeVIwVVk5RWdVQ24wMWJ6blF4WFh1c2dMVFZoZ20vbEhyWmcwQkVUczVrVzFkdjVwMjJxbGJFaGNJVDBUWjRIaW9WdWF5cGxpaWhPS1o2ZzlwTmpEL1JDRWRLME5jSHRvNEtPMFZFTWZyZ0ZBellSOUFzSGJPeHpQenNBejcvSExTNzRhOFVCaTBYenZUa3ZRVS8wUEJtSkxhRklBQVhlUXNwb2NRdGFKYTZOR2RVSXZsTzBQYTgvVzljcUJEaWhFR1c0UlptaEgzd3RHUElwVlZxVDZMcWtidnQrK3FjYkVhaE1iSEpjbEhDRkVvWU8rcExQREp3dThGSHFSU2VWelVsRlhuMFlYVFRhREdrcEgyOWJtQk9QYUZMV1BGMksyR1FJQmZ3eDUzbTdCT2lMaGZpS0ZsVmJ3QVR0Nk50aUNYdmg3aDBKYjZKbENkRjZaR29uWkVyeXVZdng2dGtvTHk0Ny9sS0N6bjY0UFFyV1l3SEsvY1VkbWwzS0RWVXhpN0RVOG1SeG1LczZ3N1c4aFJHa1FXWEhnbUJDZDlkRzk1NEJzSjc0YmIyd0UvRU1jZXU0SE1QRE5FVmNMYkdHc0t1akc2NjdhNGYybUNCenZOcnhMZUUvSXlLNjZGZGFVbzlKQkhZOWtrc1VXVzd6S2hpYmUwMGFBV3MxcDJmbitXakNDbUFGWHVudFZyMnhtOWs5T3pRalIyWXlQSzZYK3AySXgxRU9jc0kxeG9IQXRpWjVFWjlTWkxPYUhHUTBFSkFtREkwVVB2NVRjOFQ5QnJVTnBNbWhFdTZZSmM1aVZpNGJ0OGgwTjdHWHpjZHVueU4vSCt5T2xxRHUwbkdHRm1QS3JoWFJnMDNhUVVJeDJOTFRQZ240UT09IiwiZGF0YWtleSI6IkFRRUJBSGgzellPZHRwQkJTVncvWTJhbjhCWElENGt3TFFmbm9UajV6d1p0R0pab1pRQUFBSDR3ZkFZSktvWklodmNOQVFjR29HOHdiUUlCQURCb0Jna3Foa2lHOXcwQkJ3RXdIZ1lKWUlaSUFXVURCQUV1TUJFRURKUTRUeGZQd0ZVOHlLSlhsQUlCRUlBN0s4M3ZOam55TGdIZldhdE4zQlZwYXhESy9HbHRIa25yVmdqK1RQdnU4VEpCMS84cEZBalNWcWxleUpxN2hJRzBTV2hQRThCc3NROTVvTlU9IiwidmVyc2lvbiI6IjIiLCJ0eXBlIjoiREFUQV9LRVkiLCJleHBpcmF0aW9uIjoxNTI4MjI5Mzk5fQ==
```
The Kubernetes yaml file will reference the secret `regcred` in order to download the container.


## Configuration
The container require setup of the following parameter in the yaml file:
```
env:
- name:  FLUENT_SPLUNK_HOST
  value: "35.157.36.132"
- name:  FLUENT_SPLUNK_PORT
  value: "8001"
```
