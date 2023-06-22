.model small
.stack 100h

.data
    message db 0ah, 0dh, "Hosgeldiniz$" ; Hosgeldiniz mesaji
    incorrect_message db 0ah, 0dh, "Sifreniz yanlis$" ; Yanlis sifre mesaji
    enter_to_continue db 0ah, 0dh, "Geri donmek icin lutfen Enter tusuna basiniz$" ; Devam etmek icin Enter mesaji
    change_password_prompt db 0ah, 0dh, "Sifreyi degistirmek icin SPACE tusuna basin$" ; Sifre degistirme prompt mesaji
    enter_new_password_prompt db 0ah, 0dh, "Yeni sifrenizi giriniz: $" ; Yeni sifre girme prompt mesaji
    password_changed_message db 0ah, 0dh, "Sifreniz degistirildi$" ; Sifre degistirildi mesaji
    password_prompt db 0ah, 0dh, "Lutfen sifrenizi giriniz: $" ; Sifre giris prompt mesaji
    password db '1234$' ; Baslangicta gecerli olan sifre
    input_buffer db 6 dup('$') ; Kullanicidan alinacak sifre girisini tutan buffer

.code
    mov ax, @data
    mov ds, ax

main:
    call clear_screen ; Ekrani temizle
    call print_message ; Sifre giris prompt mesajini goster
    call get_password ; Kullanicidan sifreyi al
    call check_password ; Sifreyi kontrol et
    jz welcome_message ; Sifre dogruysa hosgeldin mesajini goster
    jmp incorrect_password ; Sifre yanlissa yanlis sifre mesajini goster

clear_screen:
    mov ah, 00h ; AH = 00h: Ekrani temizle islevi
    mov al, 03h ; AL = 03h: Ekrani temizle
    int 10h ; Interrup 10h ile ekrani temizle
    ret

print_message:
    mov ah, 09h ; AH = 09h: Yazi dizisi yazdir islevi
    mov dx, offset password_prompt ; Sifre giris prompt mesajinin adresini DX kaydediciye yukle
    int 21h ; Interrupt 21h ile mesaji ekrana yazdir
    ret

get_password:
    mov ah, 0ah ; AH = 0Ah: Kullanicidan karakter girisi islevi
    mov dx, offset input_buffer ; Sifre girisi icin buffer adresini DX kaydediciye yukle
    int 21h ; Interrupt 21h ile karakter girisini al
    ret

check_password:
    mov si, offset password ; Sifre dizisinin adresini SI kaydedicisine yukle
    mov di, offset input_buffer + 2 ; Kullanicinin girdigi sifrenin adresini DI kaydedicisine yukle
    mov cx, 4 ; Sifre uzunlugu (4 karakter)
check_loop:
    mov al, [si] ; Sifre dizisinden bir karakteri AL kaydedicisine yukle
    cmp al, [di] ; Kullanicinin girdigi sifre ile karsilastir
    jne incorrect_password ; Karakterler eslesmiyorsa yanlis sifre
    inc si ; Sifre dizisinde sonraki karaktere gec
    inc di ; Kullanicinin girdigi sifre dizisinde sonraki karaktere gec
    loop check_loop ; Donguyu tekrarla
    cmp byte ptr [di], 0dh ; Sifre girisi tamamlanmis mi kontrol et (Enter tusunun ASCII degeri)
    jne incorrect_password ; Tamamlanmamissa yanlis sifre
    ret

incorrect_password:
    mov ah, 09h ; AH = 09h: Yazi dizisi yazdir islevi
    mov dx, offset incorrect_message ; Yanlis sifre mesajinin adresini DX kaydediciye yukle
    int 21h ; Interrupt 21h ile mesaji ekrana yazdir
    jmp check_change_password ; Sifreyi degistirmek icin kontrol bolumune atla

welcome_message:
    mov ah, 09h ; AH = 09h: Yazi dizisi yazdir islevi
    mov dx, offset message ; Hosgeldiniz mesajinin adresini DX kaydediciye yukle
    int 21h ; Interrupt 21h ile mesaji ekrana yazdir
    jmp continue_prompt ; Devam etmek icin prompt goster

check_change_password:
    mov ah, 09h ; AH = 09h: Yazi dizisi yazdir islevi
    mov dx, offset change_password_prompt ; Sifreyi degistirmek icin SPACE tusuna basin mesajinin adresini DX kaydediciye yukle
    int 21h ; Interrupt 21h ile mesaji ekrana yazdir

    mov ah, 01h    ; Klavyeden karakter okuma
    int 21h        ; AL kaydedicisinde ASCII degeri bulunacak

    cmp al, 20h    ; SPACE tusunun ASCII degeri
    jne continue_prompt ; SPACE tusuna basilmediyse devam et
    jmp change_password ; Sifreyi degistirme bolumune atla

change_password:
    call clear_screen ; Ekrani temizle
    mov ah, 09h ; AH = 09h: Yazi dizisi yazdir islevi
    mov dx, offset enter_new_password_prompt ; Yeni sifre girisi prompt mesajinin adresini DX kaydediciye yukle
    int 21h ; Interrupt 21h ile mesaji ekrana yazdir

    call get_password ; Kullanicidan yeni sifreyi al
    mov si, offset input_buffer + 2 ; Kullanicinin girdigi sifrenin adresini SI kaydedicisine yukle
    mov di, offset password ; Sifre dizisinin adresini DI kaydediciye yukle
    mov cx, 4 ; Sifre uzunlugu (4 karakter)

copy_new_password:
    mov al, [si] ; Kullanicinin girdigi sifre karakterini AL kaydediciye yukle
    mov [di], al ; Sifre dizisine kopyala
    inc si ; Kullanicinin girdigi sifre dizisinde sonraki karaktere gec
    inc di ; Sifre dizisinde sonraki karaktere gec
    loop copy_new_password ; Donguyu tekrarla

    mov ah, 09h ; AH = 09h: Yazi dizisi yazdir islevi
    mov dx, offset password_changed_message ; Sifreniz degistirildi mesajinin adresini DX kaydediciye yukle
    int 21h ; Interrupt 21h ile mesaji ekrana yazdir
    jmp continue_prompt ; Devam etmek icin prompt goster

continue_prompt:
    mov ah, 09h ; AH = 09h: Yazi dizisi yazdir islevi
    mov dx, offset enter_to_continue ; Devam etmek icin Enter tusuna basiniz mesajinin adresini DX kaydediciye yukle
    int 21h ; Interrupt 21h ile mesaji ekrana yazdir

    mov ah, 01h    ; Klavyeden karakter okuma
    int 21h        ; AL kaydedicisinde ASCII degeri bulunacak

    cmp al, 0dh    ; Enter tusunun ASCII degeri
    jne continue_prompt ; Enter tusuna basilana kadar tekrarla

    jmp main ; Ana programa geri don
