#!/bin/bash

#subgraphs=("checkouts" "customers" "inventory" "locations" "orders" "products" "reviews")
subgraphs=("customers" "inventory" "locations" "orders" "products" "reviews")

# from https://studio.apollographql.com/graph/acephei-e-commerrce-pybpmi/service-list?currentService=inventory&range=lastDay&variant=staging
url_checkouts="https://qg4q5r6zrj.execute-api.us-east-1.amazonaws.com/Prod/graphql"
url_customers="https://eg3jdhe3zl.execute-api.us-east-1.amazonaws.com/Prod/graphql"
url_inventory="https://2lc1ekf3dd.execute-api.us-east-1.amazonaws.com/Prod/graphql"
url_locations="https://1kmwbtxfr4.execute-api.us-east-1.amazonaws.com/Prod/graphql"
url_orders="https://nem23xx1vd.execute-api.us-east-1.amazonaws.com/Prod/graphql"
url_products="https://7bssbnldib.execute-api.us-east-1.amazonaws.com/Prod/graphql"
url_reviews="https://w0jtezo2pa.execute-api.us-east-1.amazonaws.com/Prod/graphql"
