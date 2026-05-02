
iso/boot/kernel.elf:     file format elf64-x86-64


Disassembly of section .text:

0000000000110000 <_start>:
  110000:	bc 00 00 80 00       	mov    esp,0x800000
  110005:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
  110009:	48 83 ec 08          	sub    rsp,0x8
  11000d:	fa                   	cli    
  11000e:	fc                   	cld    
  11000f:	48 31 c0             	xor    rax,rax
  110012:	48 31 db             	xor    rbx,rbx
  110015:	48 31 c9             	xor    rcx,rcx
  110018:	48 31 d2             	xor    rdx,rdx
  11001b:	e8 2f 01 00 00       	call   11014f <init_paging>
  110020:	e8 96 00 00 00       	call   1100bb <main>

0000000000110025 <_start.hang>:
  110025:	f4                   	hlt    
  110026:	eb fd                	jmp    110025 <_start.hang>

0000000000110028 <strncmp>:
  110028:	55                   	push   rbp
  110029:	48 89 e5             	mov    rbp,rsp
  11002c:	48 83 ec 28          	sub    rsp,0x28
  110030:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  110034:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
  110038:	48 89 55 d8          	mov    QWORD PTR [rbp-0x28],rdx
  11003c:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
  110043:	00 
  110044:	eb 64                	jmp    1100aa <strncmp+0x82>
  110046:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  11004a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  11004e:	48 01 d0             	add    rax,rdx
  110051:	0f b6 10             	movzx  edx,BYTE PTR [rax]
  110054:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
  110058:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  11005c:	48 01 c8             	add    rax,rcx
  11005f:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  110062:	38 c2                	cmp    dl,al
  110064:	74 26                	je     11008c <strncmp+0x64>
  110066:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  11006a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  11006e:	48 01 d0             	add    rax,rdx
  110071:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  110074:	0f b6 c0             	movzx  eax,al
  110077:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
  11007b:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
  11007f:	48 01 ca             	add    rdx,rcx
  110082:	0f b6 12             	movzx  edx,BYTE PTR [rdx]
  110085:	0f b6 d2             	movzx  edx,dl
  110088:	29 d0                	sub    eax,edx
  11008a:	eb 2d                	jmp    1100b9 <strncmp+0x91>
  11008c:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
  110090:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  110094:	48 01 d0             	add    rax,rdx
  110097:	0f b6 00             	movzx  eax,BYTE PTR [rax]
  11009a:	84 c0                	test   al,al
  11009c:	75 07                	jne    1100a5 <strncmp+0x7d>
  11009e:	b8 00 00 00 00       	mov    eax,0x0
  1100a3:	eb 14                	jmp    1100b9 <strncmp+0x91>
  1100a5:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  1100aa:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1100ae:	48 3b 45 d8          	cmp    rax,QWORD PTR [rbp-0x28]
  1100b2:	72 92                	jb     110046 <strncmp+0x1e>
  1100b4:	b8 00 00 00 00       	mov    eax,0x0
  1100b9:	c9                   	leave  
  1100ba:	c3                   	ret    

00000000001100bb <main>:
  1100bb:	55                   	push   rbp
  1100bc:	48 89 e5             	mov    rbp,rsp
  1100bf:	48 83 ec 20          	sub    rsp,0x20
  1100c3:	48 c7 45 f0 00 80 0b 	mov    QWORD PTR [rbp-0x10],0xb8000
  1100ca:	00 
  1100cb:	48 8d 05 3b 01 00 00 	lea    rax,[rip+0x13b]        # 11020d <init_paging+0xbe>
  1100d2:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
  1100d6:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [rbp-0x4],0x0
  1100dd:	eb 20                	jmp    1100ff <main+0x44>
  1100df:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  1100e2:	83 c0 30             	add    eax,0x30
  1100e5:	80 cc 0f             	or     ah,0xf
  1100e8:	89 c2                	mov    edx,eax
  1100ea:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  1100ed:	48 98                	cdqe   
  1100ef:	48 01 c0             	add    rax,rax
  1100f2:	48 05 00 80 0b 00    	add    rax,0xb8000
  1100f8:	66 89 10             	mov    WORD PTR [rax],dx
  1100fb:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
  1100ff:	83 7d fc 09          	cmp    DWORD PTR [rbp-0x4],0x9
  110103:	7e da                	jle    1100df <main+0x24>
  110105:	90                   	nop
  110106:	90                   	nop
  110107:	c9                   	leave  
  110108:	c3                   	ret    

0000000000110109 <_Z3mapmm>:
  110109:	55                   	push   rbp
  11010a:	48 89 e5             	mov    rbp,rsp
  11010d:	48 83 ec 20          	sub    rsp,0x20
  110111:	48 89 7d e8          	mov    QWORD PTR [rbp-0x18],rdi
  110115:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
  110119:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
  11011d:	48 c1 e8 0c          	shr    rax,0xc
  110121:	25 ff 01 00 00       	and    eax,0x1ff
  110126:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
  11012a:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
  11012e:	48 83 c8 03          	or     rax,0x3
  110132:	48 89 c1             	mov    rcx,rax
  110135:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  110139:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
  110140:	00 
  110141:	48 8d 05 b8 3e 00 00 	lea    rax,[rip+0x3eb8]        # 114000 <_ZL2pt>
  110148:	48 89 0c 02          	mov    QWORD PTR [rdx+rax*1],rcx
  11014c:	90                   	nop
  11014d:	c9                   	leave  
  11014e:	c3                   	ret    

000000000011014f <init_paging>:
  11014f:	55                   	push   rbp
  110150:	48 89 e5             	mov    rbp,rsp
  110153:	48 83 ec 10          	sub    rsp,0x10
  110157:	48 8d 05 a2 1e 00 00 	lea    rax,[rip+0x1ea2]        # 112000 <_ZL4pdpt>
  11015e:	48 83 c8 03          	or     rax,0x3
  110162:	48 89 05 97 0e 00 00 	mov    QWORD PTR [rip+0xe97],rax        # 111000 <_ZL4pml4>
  110169:	48 8d 05 90 2e 00 00 	lea    rax,[rip+0x2e90]        # 113000 <_ZL2pd>
  110170:	48 83 c8 03          	or     rax,0x3
  110174:	48 89 05 85 1e 00 00 	mov    QWORD PTR [rip+0x1e85],rax        # 112000 <_ZL4pdpt>
  11017b:	48 8d 05 7e 3e 00 00 	lea    rax,[rip+0x3e7e]        # 114000 <_ZL2pt>
  110182:	48 83 c8 03          	or     rax,0x3
  110186:	48 89 05 73 2e 00 00 	mov    QWORD PTR [rip+0x2e73],rax        # 113000 <_ZL2pd>
  11018d:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
  110194:	00 
  110195:	eb 23                	jmp    1101ba <init_paging+0x6b>
  110197:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  11019b:	48 c1 e0 0c          	shl    rax,0xc
  11019f:	48 89 c2             	mov    rdx,rax
  1101a2:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
  1101a6:	48 c1 e0 0c          	shl    rax,0xc
  1101aa:	48 89 d6             	mov    rsi,rdx
  1101ad:	48 89 c7             	mov    rdi,rax
  1101b0:	e8 54 ff ff ff       	call   110109 <_Z3mapmm>
  1101b5:	48 83 45 f8 01       	add    QWORD PTR [rbp-0x8],0x1
  1101ba:	48 81 7d f8 ff 01 00 	cmp    QWORD PTR [rbp-0x8],0x1ff
  1101c1:	00 
  1101c2:	76 d3                	jbe    110197 <init_paging+0x48>
  1101c4:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
  1101cb:	00 
  1101cc:	eb 28                	jmp    1101f6 <init_paging+0xa7>
  1101ce:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1101d2:	48 8d 90 00 00 80 00 	lea    rdx,[rax+0x800000]
  1101d9:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
  1101dd:	48 05 00 00 80 00    	add    rax,0x800000
  1101e3:	48 89 d6             	mov    rsi,rdx
  1101e6:	48 89 c7             	mov    rdi,rax
  1101e9:	e8 1b ff ff ff       	call   110109 <_Z3mapmm>
  1101ee:	48 81 45 f0 00 10 00 	add    QWORD PTR [rbp-0x10],0x1000
  1101f5:	00 
  1101f6:	48 81 7d f0 ff ff 01 	cmp    QWORD PTR [rbp-0x10],0x1ffff
  1101fd:	00 
  1101fe:	76 ce                	jbe    1101ce <init_paging+0x7f>
  110200:	48 8d 05 f9 0d 00 00 	lea    rax,[rip+0xdf9]        # 111000 <_ZL4pml4>
  110207:	0f 22 d8             	mov    cr3,rax
  11020a:	90                   	nop
  11020b:	c9                   	leave  
  11020c:	c3                   	ret    
