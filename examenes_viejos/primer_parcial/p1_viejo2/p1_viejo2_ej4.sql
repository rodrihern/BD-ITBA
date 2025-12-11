CREATE TABLE R (
    a1 INT NOT NULL,
    b1 INT NOT NULL,
    d1 INT NOT NULL,
    c1 INT NOT NULL,
    -- Claves candidatas
    PRIMARY KEY (a1, b1, d1),
    UNIQUE (c1),
    -- Claves foráneas
    FOREIGN KEY (a1) REFERENCES A(a1),
    FOREIGN KEY (b1) REFERENCES B(b1),
    FOREIGN KEY (d1) REFERENCES D(d1),
    FOREIGN KEY (c1) REFERENCES C(c1)
);
