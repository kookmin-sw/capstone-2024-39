insert into member (id, email, name, age, gender, created_at) values
(UNHEX(REPLACE("3f06af63-a93c-11e4-9797-00505690773f", "-","")), 'example1@gmail.com', '홍길동1', 17, '남자', '2023-05-16 15:48:57.450179');
insert into member (id, email, name, age, gender, created_at) values
(UNHEX(REPLACE("8fbcec61-e527-15ee-bd3d-0242ac120002", "-","")), 'example2@gmail.com', '홍길동2', 17, '남자', '2023-05-26 15:48:57.450179');
insert into member (id, email, name, age, gender, created_at) values
(UNHEX(REPLACE("8fbcec62-e527-14ee-bd3d-0242ac120002", "-","")), 'example3@gmail.com', '홍길동3', 17, '남자', '2023-05-26 15:48:57.450179');
insert into member (id, email, name, age, gender, created_at) values
(UNHEX(REPLACE("8fbcec63-e527-10ee-bd3d-0242ac120002", "-","")), 'example4@gmail.com', '홍길동4', 17, '남자', '2023-05-26 15:48:57.450179');
insert into member (id, email, name, age, gender, created_at) values
(UNHEX(REPLACE("8fbcec64-e527-11ee-bd3d-0242ac120002", "-","")), 'example5@gmail.com', '홍길동5', 17, '남자', '2023-05-26 15:48:57.450179');
insert into member (id, email, name, age, gender, created_at) values
(UNHEX(REPLACE("8fbcec65-e527-12ee-bd3d-0242ac120002", "-","")), 'example6@gmail.com', '홍길동6', 17, '남자', '2023-05-26 15:48:57.450179');

insert into book (id, title, category_1d, category_2d, category_3d, author, publisher, publish_date) values
(1, '제목1', '카테고리1', '카테고리2', '카테고리3', '저자1', '출판사1', '2022-04-10');
insert into book (id, title, category_1d, category_2d, category_3d, author, publisher, publish_date) values
(2, '제목2', '카테고리1', '카테고리2', '카테고리3', '저자2', '출판사2', '2022-04-10');
insert into book (id, title, category_1d, category_2d, category_3d, author, publisher, publish_date) values
(3, '제목3', '카테고리1', '카테고리2', '카테고리3', '저자3', '출판사3', '2022-04-10');
insert into book (id, title, category_1d, category_2d, category_3d, author, publisher, publish_date) values
(4, '제목4', '카테고리1', '카테고리2', '카테고리3', '저자4', '출판사4', '2022-04-10');
insert into book (id, title, category_1d, category_2d, category_3d, author, publisher, publish_date) values
(5, '제목5', '카테고리1', '카테고리2', '카테고리3', '저자5', '출판사5', '2022-04-10');


insert into club (id, manager_id, topic, name, created_at, maximum, public_status, password, book_id) values
(1, UNHEX(REPLACE("3f06af63-a93c-11e4-9797-00505690773f", "-","")), '역사', '길동1의 모임', '2023-05-26 15:48:57.450179', 10, 'PUBLIC', null, 1);
insert into club (id, manager_id, topic, name, created_at, maximum, public_status, password, book_id) values
(2, UNHEX(REPLACE("8fbcec61-e527-15ee-bd3d-0242ac120002", "-","")), '경제', '길동2의 모임', '2023-05-26 15:48:57.450179', 10, 'PUBLIC', null, null);
insert into club (id, manager_id, topic, name, created_at, maximum, public_status, password, book_id) values
(3, UNHEX(REPLACE("8fbcec62-e527-14ee-bd3d-0242ac120002", "-","")), '종교', '길동3의 모임', '2023-05-26 15:48:57.450179', 10, 'PUBLIC', null, 2);
insert into club (id, manager_id, topic, name, created_at, maximum, public_status, password, book_id) values
(4, UNHEX(REPLACE("8fbcec63-e527-10ee-bd3d-0242ac120002", "-","")), '사회', '길동4의 모임', '2023-05-26 15:48:57.450179', 10, 'PUBLIC', null, 3);

insert into club (id, manager_id, topic, name, created_at, maximum, public_status, password, book_id) values
(5, UNHEX(REPLACE("3f06af63-a93c-11e4-9797-00505690773f", "-","")), '역사', '길동1의 모임', '2023-05-26 15:48:57.450179', 10, 'PUBLIC', null, 1);
insert into club (id, manager_id, topic, name, created_at, maximum, public_status, password, book_id) values
(6, UNHEX(REPLACE("8fbcec61-e527-15ee-bd3d-0242ac120002", "-","")), '경제', '길동2의 모임', '2023-05-26 15:48:57.450179', 10, 'PUBLIC', null, null);
insert into club (id, manager_id, topic, name, created_at, maximum, public_status, password, book_id) values
(7, UNHEX(REPLACE("8fbcec62-e527-14ee-bd3d-0242ac120002", "-","")), '종교', '길동3의 모임', '2023-05-26 15:48:57.450179', 10, 'PUBLIC', null, 2);
insert into club (id, manager_id, topic, name, created_at, maximum, public_status, password, book_id) values
(8, UNHEX(REPLACE("8fbcec63-e527-10ee-bd3d-0242ac120002", "-","")), '사회', '길동4의 모임', '2023-05-26 15:48:57.450179', 10, 'PUBLIC', null, 3);

