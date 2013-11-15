-- Enable foreign keys support
PRAGMA foreign_keys = ON;

-------------------------------------------------------------------------------
CREATE TABLE dataset
(
        id      INTEGER PRIMARY KEY,
        hash    TEXT NOT NULL
);

CREATE UNIQUE INDEX idx_dataset_id ON dataset( id );
-- CREATE UNIQUE INDEX idx_dataset_hash ON dataset( hash );

-------------------------------------------------------------------------------
CREATE TABLE dataset_tag
(
        id              INTEGER PRIMARY KEY,
        parent_id       INTEGER NOT NULL DEFAULT 0 REFERENCES tag( id )
        label           TEXT NOT NULL
);

CREATE UNIQUE INDEX idx_ds_tag_id ON dataset_tag( id );
CREATE UNIQUE INDEX idx_ds_tag_label ON dataset_tag( label );

INSERT INTO tag( id, parent_id, label )
VALUES( 0, 0, 'dataset' )
VALUES( 1, 0, 'cache' )
VALUES( 2, 0, 'database' );

-------------------------------------------------------------------------------
CREATE TABLE dataset_memberships
(
        id              INTEGER PRIMARY KEY,
        dataset_id      INTEGER NOT NULL REFERENCES dataset( id ),
        tag_id          INTEGER NOT NULL REFERENCES tag( id )
);

CREATE UNIQUE INDEX idx_memberships_dataset_id ON memberships( dataset_id );
CREATE UNIQUE INDEX idx_memberships_dataset_tag_id ON memberships( tag_id );

-------------------------------------------------------------------------------
CREATE TABLE dataset_attrbutes
(
        id              INTEGER PRIMARY KEY,
        dataset_id      INTEGER NOT NULL REFERENCES dataset( id ),
        rank            INTEGER NOT NULL
        name            TEXT NOT NULL,
        value           TEXT,
);

CREATE UNIQUE INDEX idx_dataset_attributes_id ON dataset_attributes( id );
CREATE INDEX idx_dataset_attributes_dsid ON dataset_attributes( dsid );

-------------------------------------------------------------------------------
-- .import 'data/dataset.csv' dataset
-- .import 'data/tag.csv' tag
-- .import 'data/memberships.csv' memberships
-- .import 'data/dataset_attributes.csv' dataset_attributes

-- .mode tabs

-- SELECT dataset.id, tag.name, dataset.ref FROM dataset, tag
-- JOIN memberships ON
--      (memberships.dataset_id=dataset.id AND memberships.tag_id=tag.id)
-- WHERE tag.name='Quality Images'
-- ORDER BY dataset.id

-- SELECT d.* FROM dataset AS d JOIN memberships AS dt ON dt.dataset_id = d.id JOIN tag AS t ON t.id = dt.tid WHERE t.name = 'Quality Images';

-- SELECT d.* FROM dataset AS d JOIN dataset_attributes AS dp ON dp.dsid = d.id WHERE dp.name = 'licence' AND dp.value = 'CC By-SA 3.0';

-- SELECT dp.value, d.name FROM dataset AS d JOIN dataset_attributes AS dp ON dp.dsid = d.id WHERE dp.name = 'licence' AND dp.rank = 1 ORDER BY dp.value, d.name;

-- SELECT dp.value, d.name FROM dataset AS d JOIN dataset_attributes AS dp ON dp.dsid = d.id WHERE dp.name = 'author' ORDER BY dp.value;
