FROM python:3.12.1-alpine3.19
LABEL maintainer="henrygzanin@gmail.com"

#Essa variável de ambiente é usada para controlar se o python deve gravar aquivos
#de bytecode (.pyc) no disco. 1=Não, 0=Sim
ENV PYTHONDONTWRITEBYTECODE 1

#Define que a saída do python será exibida imediatamente no console ou em
#outros dipositivos de saída, ao invés de ser armazenada em um buffer
#em resumo, será visualisado outputs do python em tempo real
ENV PYTHONUNBUFFERED 1

#Copia a pasta "djangoapp" e "scripts" para dentro do container
COPY ./djangoapp /djangoapp
COPY ./scripts /scripts

#entra na pasta djangoapp no container
WORKDIR /djangoapp

#A porta 8000 estará disponiveis para conexões externas ao container
#É a porta que o django irá usar
EXPOSE 8000

#RUN executa comandos no terminal do container para construir a imagem
#O resultado da execução do comando é armazenado no sistema de arquivos
#da imagem como uma nova camada.
#Agrupar comandos RUN em uma única instrução reduz o número de camadas
#tornando a imagem menor e mais eficiente.
RUN python -m venv /venv && \
  /venv/bin/pip install --upgrade pip && \
  /venv/bin/pip install -r /djangoapp/requirements.txt && \
  adduser --disabled-password --no-create-home duser && \
  mkdir -p /data/web/static && \
  mkdir -p /data/web/media && \
  chown -R duser:duser /venv && \
  chown -R duser:duser /data/web/static && \
  chown -R duser:duser /data/web/media && \
  chmod -R 755 /data/web/static && \
  chmod -R 755 /data/web/media && \
  chmod -R +x /scripts

#Adiciona a pasta scripts e venv/bin no PATH do container
ENV PATH="/scripts:/venv/bin:$PATH"

#muda o usuário para duser
USER duser

#executa o arquivo scipypts/commands.sh
CMD ["commands.sh"]