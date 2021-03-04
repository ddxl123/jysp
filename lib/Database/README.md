每个 R 表都要有 created_at、updated_at，即每个关联表都必须要有产生关联的时间，也方便于今后分表时，利用时间范围来解决分表的自增 id 问题。
同时，每张非 R 表的每行数据都必须有 created_at、updated_at，同样便于今后解决分表问题。
