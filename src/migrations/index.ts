import * as migration_20250818_051511 from './20250818_051511';

export const migrations = [
  {
    up: migration_20250818_051511.up,
    down: migration_20250818_051511.down,
    name: '20250818_051511'
  },
];
