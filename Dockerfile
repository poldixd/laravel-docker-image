FROM php:7.3-cli-alpine

# Install dev dependencies
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    curl-dev \
    imagemagick-dev \
    libtool \
    libxml2-dev \
    postgresql-dev \
    sqlite-dev

# Install production dependencies
RUN apk add --no-cache \
    bash \
    curl \
    g++ \
    gcc \
    git \
    imagemagick \
    libc-dev \
    libpng-dev \
    make \
    mysql-client \
    nodejs \
    nodejs-npm \
    openssh-client \
    postgresql-libs \
    rsync \
    gmp \
    gmp-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    zlib-dev \
    icu-dev \
    libzip-dev

# Install PECL and PEAR extensions
RUN pecl install \
    imagick \
    xdebug

RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar > phpcs && \
    chmod a+x phpcs && \
    mv phpcs /usr/local/bin

RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar > phpcbf && \
    chmod a+x phpcbf && \
    mv phpcbf /usr/local/bin

RUN docker-php-ext-configure \
    gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/

RUN docker-php-ext-enable \
    imagick \
    xdebug

RUN docker-php-ext-install \
    curl \
    iconv \
    mbstring \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pcntl \
    tokenizer \
    xml \
    gd \
    zip \
    bcmath \
    gmp \
    exif \
    intl

# Install composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="./vendor/bin:$PATH"

# Cleanup dev dependencies
RUN apk del -f .build-deps

# Setup working directory
WORKDIR /var/www
