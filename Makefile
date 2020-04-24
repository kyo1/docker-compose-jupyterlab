NAME := jupyter

all:
	docker build -t $(NAME) .
	docker run --rm -p 8888:8888 -v $(PWD)/notebook:/home/jupyter/notebook --name $(NAME) $(NAME)

update:
	git pull
