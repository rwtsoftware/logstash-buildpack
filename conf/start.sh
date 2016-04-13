export APP_ROOT=$HOME

erb $APP_ROOT/nginx.conf.erb > $APP_ROOT/nginx.conf

mkfifo $APP_ROOT/.bp/nginx/logs/access.log
mkfifo $APP_ROOT/.bp/nginx/logs/error.log

cat < $APP_ROOT/.bp/nginx/logs/access.log &
(>&2 cat) < $APP_ROOT/.bp/nginx/logs/error.log &

exec nginx -p $APP_ROOT/.bp/nginx -c $APP_ROOT/nginx.conf &
exec logstash agent -f ./logstash.conf &
wait
