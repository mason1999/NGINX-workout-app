#! /usr/bin/bash
TFVARS_FILE="./infrastructure-code/terraform.tfvars"
DATABASE_MONGODB_VARIABLE="DATABASE_MONGODB_DNS_NAME"
BACKEND_VARIABLE="BACKEND_DNS_NAME"
FRONTEND_VARIABLE="FRONTEND_DNS_NAME"

database_mongodb_replace() {
    database_mongodb_input_name=$(cat "${TFVARS_FILE}" | grep "${DATABASE_MONGODB_VARIABLE}" | grep -Eo '".*"' | grep -Eo '[^"]+')

    # Update here for more occurences of files where mongodb needs to be referenced.
    sed -i "s/${DATABASE_MONGODB_VARIABLE}/$(echo ${database_mongodb_input_name})/g" "./app-code/backend/.env"
    sed -i "s/${DATABASE_MONGODB_VARIABLE}/$(echo ${database_mongodb_input_name})/g" "./app-code/docker-compose.yml"
}

backend_replace() {
    backend_input_name=$(cat "${TFVARS_FILE}" | grep "${BACKEND_VARIABLE}" | grep -Eo '".*"' | grep -Eo '[^"]+')

    # Update here for more occurences of files where backend needs to be referenced.
    sed -i "s/${BACKEND_VARIABLE}/$(echo ${backend_input_name})/g" "./app-code/docker-compose.yml"
    sed -i "s/${BACKEND_VARIABLE}/$(echo ${backend_input_name})/g" "./app-code/frontend/nginx.conf"
}

frontend_replace() {
    frontend_input_name=$(cat "${TFVARS_FILE}" | grep "${FRONTEND_VARIABLE}" | grep -Eo '".*"' | grep -Eo '[^"]+')

    # Update here for more occurences of files where frontend needs to be referenced.
    sed -i "s/${FRONTEND_VARIABLE}/$(echo ${frontend_input_name})/g" "./app-code/docker-compose.yml"
}

########## BEGIN SCRIPT ##########
getopts "cdh" option
case $option in
    c)
    cp -r "app-code-template" "app-code"
    database_mongodb_replace
    backend_replace
    frontend_replace
    ;;

    d)
    rm -rf "app-code"
    ;;

    h)
    help
    ;;

    ?)
    cat << 'EOF'
Illegal option entered. The available options [-c|-d|-h] are:
    -c: Creating and running images and containers
    -d: Stopping and removing images and containers
    -h: Getting help for the script

In the script, we don't use getopts in a while loop, so only the first option will be recognized. That is:
    <script name> -cda : -c will be seen as the parameter
    <script name> -dca : -d will be seen as the parameter
    <script name> -acd : -a will be seen as the parameter
EOF
    ;;
esac
