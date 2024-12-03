FROM project:symfony-php-8-2-alpine
COPY . /project/
WORKDIR /project
CMD ["php", "-a"]