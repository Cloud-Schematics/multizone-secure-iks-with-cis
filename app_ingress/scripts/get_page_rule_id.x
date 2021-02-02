
CRN=crn:v1:bluemix:public:internet-svcs:global:a/cdefe6d99f7ea459aacb25775fb88a33:9e3faa6d-b3f6-45b5-a08f-e502ab9c8918::
DOMAIN_ID=a24fea7a5af495195e12217c8d12eccd
INGRESS_SUBDOMAIN_URL=test.jv-dev-dev-cluster-4d801e9c87f3c801465049d014041247-0000.eu-gb.containers.appdomain.cloud

TOKEN=$(
  echo $(
    curl -s -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      --data-urlencode "apikey=$API_KEY" \
      "https://iam.cloud.ibm.com/identity/token"
  ) | jq  -r .access_token
)


RESULTS=$(curl -X GET \
    https://api.cis.cloud.ibm.com/v1/$CRN/zones/$DOMAIN_ID/pagerules \
    -H 'content-type: application/json' \
    -H 'accept: application/json' \
    -H "x-auth-user-token: Bearer $TOKEN" | jq ".result")

RULES_COUNT=$(echo $RESULTS | jq ". | length")
RESULTS_LENGTH=$((RULES_COUNT - 1))

PAGE_RULE_ID=todd

for i in $(seq 0 $RESULTS_LENGTH)
do
    RESULT_ACTION_ID=$(echo $RESULTS | jq -r ".[$i].actions[0].id")
    RESULT_ACTION_VALUE=$(echo $RESULTS | jq  -r ".[$i].actions[0].value")
    if [ "$RESULT_ACTION_ID" == "host_header_override" ] && [ "$RESULT_ACTION_VALUE" == "$INGRESS_SUBDOMAIN_URL" ] ; then
        PAGE_RULE_ID=$(echo $RESULTS | jq -r ".[$i].id")
    fi
done


curl -X DELETE \
    https://api.cis.cloud.ibm.com/v1/$CRN/zones/$DOMAIN_ID/pagerules/$PAGE_RULE_ID \
    -H 'content-type: application/json' \
    -H 'accept: application/json' \
    -H "x-auth-user-token: Bearer $TOKEN"
    
jq -n '{ "page_rule_id" :  "'$PAGE_RULE_ID'"}'