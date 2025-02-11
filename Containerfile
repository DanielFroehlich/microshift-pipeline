FROM quay.coe.muc.redhat.com/proxy_registry_redhat_io/ubi9/ubi
RUN  yum -y install net-tools bind-utils iputils less strace tcpdump nmap-ncat iperf3 vim-minimal socat hostname stress-ng fio && \
     yum clean all
#RUN echo "Daniel was here" >test.txt
