FROM centos:7
MAINTAINER newrain_wang@163.com
RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs ; \
yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*; \
yum install -y wget && \
rm -rf /etc/yum.repos.d/* && \
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && \
wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo && \
yum clean all && yum makecache && \
yum -y install php php-mysql gd php-gd php-fpm && \
rm -rf /etc/nginx/nginx.conf /usr/share/nginx/html/* && \
yum clean all
COPY nginx.conf /etc/nginx/
COPY entrypoint.sh /entrypoint.sh
ADD ["wordpress-4.9.4-zh_CN.tar.gz","/usr/share/nginx/"]
RUN chown nginx.nginx /usr/share/nginx -R
EXPOSE 80 443
VOLUME ["/etc/nginx","/usr/share/nginx"]
CMD ["sh" ,"/entrypoint.sh"]
