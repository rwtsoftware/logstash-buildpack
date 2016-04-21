export APP_ROOT=$HOME

erb $APP_ROOT/nginx.conf.erb > $APP_ROOT/nginx.conf

mkfifo $APP_ROOT/../logs/nginx_access.log
mkfifo $APP_ROOT/../logs/nginx_error.log

cat < $APP_ROOT/../logs/nginx_access.log &
(>&2 cat) < $APP_ROOT/../logs/nginx_error.log &

exec nginx -p $APP_ROOT/.bp/nginx -c $APP_ROOT/nginx.conf &
PID_NGINX=$!

mkfifo $APP_ROOT/../logs/logstash.log

cat < $APP_ROOT/../logs/logstash.log &

exec logstash agent -f ./logstash.conf &
PID_LOGSTASH=$!

wait $PID_NGINX
wait $PID_LOGSTASH
