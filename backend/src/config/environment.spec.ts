import { parseCorsOrigins } from './environment';

describe('parseCorsOrigins', () => {
  it('chuẩn hóa danh sách origin', () => {
    expect(parseCorsOrigins(' http://localhost:5173, ,http://127.0.0.1:8088 ')).toEqual([
      'http://localhost:5173',
      'http://127.0.0.1:8088',
    ]);
  });

  it('trả về danh sách rỗng khi chưa cấu hình', () => {
    expect(parseCorsOrigins(undefined)).toEqual([]);
  });
});
