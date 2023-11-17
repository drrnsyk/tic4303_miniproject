drop schema if exists miniproject;

create database miniproject;

USE miniproject;

create table users (
	id int auto_increment not null,
	email varchar(255),
	name varchar(255),
	password varchar(255),
	role varchar(255),
	primary key (id)
);

insert into users (id, email, name, password, role) values ('1', 'admin@gmail.com', 'Administrator',  '$2a$12$122ZD9ZaPutMwU4XxT/.VOglGwSz6YzYVcw/gAmyRdQ7xLciCjThW', 'ADMIN');

create table interests (
	id int auto_increment not null,
    name varchar(255),
    email varchar(255),
    phone varchar(255),
    country varchar(255),
    gender varchar(255),
    qualification varchar(255),
    primary key (id)
);