# Fibonacci  
```
Code chương trình thực hiện tính số fibbonaci thứ N(N được nhập vào từ bàn phím)
(yêu cầu cho code bằng DP là phải đúng với cả trường hợp số lớn)
Yêu cầu:
    - chạy được
    - bắt buộc tất cả các bài phải xây dựng hàm xử lý(vd bài fibonacci phải có hàm tính fibbonacci, bài, chuyển đổi cơ số phải có hàm chuyển đổi...)
    - Input mặc định là string, xây dựng hàm convert string -> num, cộng trừ số lớn...
```
bài asm đầu tiên mình viết nên khá nhiều rác và không được clean cho lắm  
## Một số thứ đáng chú ý:  
Gọi API thông thường như nhập, xuất từ bàn phím ra cửa số cmd có thể dùng invoke hoặc push-call  
  
```assembly
invoke GetStdHandle, STD_OUTPUT_HANDLE; gọi handle output
mov hConsoleOut, eax 
    
invoke GetStdHandle, STD_INPUT_HANDLE; gọi handle input
mov hConsoleIn, eax

invoke WriteConsoleA, hConsoleOut, addr chao, chao_len, chao_read, 0  ;ghi ra màn hình 
invoke ReadConsoleA, hConsoleIn, addr buf, 256, addr buf_read, 0  ;nhập vào từ bàn phím
```

Vì trong masm 32 bit chỉ xử lý được số tối đa 4 bytes (32bit) nên khi muốn làm việc với số lớn ta phải tự xây dựng lại hàm tính toán dựa trên nguyên tắc cộng trừ thông thường ở tiểu học  
Ý tưởng:
```
92+54
ta bỏ vào 2 mảng {9,2} và {5,4}
tạo 1 mảng lưu lớn hơn độ dài mảng lớn nhất ít nhất 1 đơn vị
cộng từ phải qua trái
tạo số dư bằng 0
dư+2+4->{6} (dư 0)
dư+9+5->{6,4} (dư 1)
dư+0+0->{6,4,1} (dư 0)
cộng mỗi phần tử trong mảng mới với 0x30 (0+"0"= "0", 1+"0"= "1"...)
đảo ngược mảng và in ra màn hình
```
# RC4  
```
Code chương trình mã hóa RC4, nhập(string) và xuất(hex) trên console.
```
RC4 là thuật toán mã hóa dòng, tương tự với salsa20 và chacha20 (về cơ bản là khởi tạo key giả ngẫu nhiên và xor với plaintext, vì là xor nên có thể dùng chương trình encrypt để decrypt và ngược lại)    
thuật toán khá đơn giản, có thể tham khảo mã python sau:  
```python
data = input()
key = "4444"

S = list(range(256))
j = 0
out = ''

# KSA Phase
for i in range(256):
    j = (j + S[i] + ord(key[i % len(key)])) % 256
    S[i], S[j] = S[j], S[i]

# PRGA Phase
i = j = 0
for char in data:
    i = (i + 1) % 256
    j = (j + S[i]) % 256
    S[i], S[j] = S[j], S[i]
    out += chr(ord(char) ^ S[(S[i] + S[j]) % 256])

print(out)
```
  
Ý tưởng việc xuất hex ra màn hình:
```
tạo 1 bảng ánh xạ sym = "0123456789abcdef"
kiểm tra từng phần tử trong mảng cần xuất hex, ánh xạ với sym (1->"1", 10-> "a", 15-> "f"...)
```
# LinkedList  
```
Code chương trình xây dựng lại stack bằng danh sách liên kết(khởi tạo các node bằng malloc()), thực hiện chuyển đổi cơ số từ 10 sang các cơ số khác, Nhập xuất trên console.
Input mặc định là string, xây dựng hàm convert string -> num, cộng trừ số lớn
```
Bài khoai nhất trong task1  
Ý tưởng tạo danh sách liên kết đơn:  
```
Node:
node gồm 2 thành phần cơ bản là value và con trỏ
ta cấp phát 1 vùng nhớ bằng malloc(), trong x86 ta khởi tạo vùng nhớ 8 bytes, với 4 bytes cho value và 4 bytes lưu địa chỉ node tiếp theo
address của vùng nhớ này sẽ được tự động lưu vào eax sau khi gọi malloc()
PUSH:
tạo node
ghi address node trước đó vào 4 bytes trống trong node này
ghi value
ghi adrress node hiện tại vào 1 biến để node tiếp theo có thể trỏ đến
POP:
lưu address của node hiện tại vào 1 biến để có thể gọi free() sau khi pop
lấy value của node này ra
bỏ address của node dưới vào 1 biến để có thể trỏ đến node đó
gọi free() để giải phóng bộ nhớ 
```
Ngoài ra việc chuyển đổi cơ số của số lớn cũng khá phức tạp  
Ý tưởng việc chuyển đổi cơ số của số lớn (cơ số 10 sang cơ số 2):  
```
mảng chứa số lớn: {9,8,7,6....7,8,9...}
chia phần tử đầu tiên trong mảng cho 2
đẩy phần nguyên sau khi bị chia vào lại mảng -> {4,8,7....7,8,9...}
nhân phần dư với 10 rồi cộng với phần tử tiếp theo trong mảng để tiếp tục chia (9%2=1, (1*10+8) /2 =9) -> {4,9,7....7,8,9...}
tiếp tục cho đến phần tử cuối cùng trong mảng sẽ còn lại phần dư
đẩy phần dư ấy vào danh sách liên kết, khi cần dùng đến sẽ pop để gọi ra
lặp lại quá trình đấy cho đến khi tất cả các phần tử trong mảng đều bằng 0
```
Áp dụng với chuyển đổi cơ số 10 sang cơ số 8, 16... cũng tương tự
