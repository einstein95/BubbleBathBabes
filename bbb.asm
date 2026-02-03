; ============================================================================
; BUBBLE BATH BABES (NES/Unlicensed) - Annotated Disassembly
; ============================================================================
; PRG CRC32: 71547d94
; CHR CRC32: 7505b144
; Overall CRC32: 68afef5f
; Code Base Address: $8000
;
; This is an unlicensed adult-themed puzzle game for the NES.
; Mapper: Sachen SA-008-A (Mapper 148)
; ============================================================================

.setcpu "6502x"

; ============================================================================
; iNES ROM HEADER
; ============================================================================
.segment "HEADER"
    .byte "NES", $1A        ; iNES magic signature
    .byte $02               ; 2 x 16KB PRG-ROM banks (32KB total)
    .byte $08               ; 8 x 8KB CHR-ROM banks (64KB total)
    .byte $41               ; Mapper D0..D3, Vertical mirroring
    .byte $98               ; Mapper D4..D7, NES 2.0 format, NES
    .byte $00               ; Mapper D8..D11, Submapper
    .byte $00               ; PRG-/CHR-ROM size MSB
    .byte $00               ; No PRG-RAM/EEPROM
    .byte $00               ; No CHR-RAM
    .byte $00               ; NTSC NES
    .byte $00               ; System: NES
    .byte $00               ; No misc ROMs
    .byte $01               ; NES controller as default expansion

; ============================================================================
; NES PPU REGISTERS
; ============================================================================
PPU_CTRL        = $2000     ; PPU Control Register
PPU_MASK        = $2001     ; PPU Mask Register
PPU_STATUS      = $2002     ; PPU Status Register
OAM_ADDR        = $2003     ; OAM Address Register
PPU_SCROLL      = $2005     ; PPU Scroll Register
PPU_ADDR        = $2006     ; PPU Address Register
PPU_DATA        = $2007     ; PPU Data Register

; ============================================================================
; NES APU REGISTERS
; ============================================================================
APU_PL1_VOL     = $4000     ; Pulse 1 Volume/Envelope
APU_PL1_SWEEP   = $4001     ; Pulse 1 Sweep
APU_PL1_LO      = $4002     ; Pulse 1 Timer Low
APU_PL1_HI      = $4003     ; Pulse 1 Timer High/Length

; ============================================================================
; OTHER NES REGISTERS
; ============================================================================
OAM_DMA         = $4014     ; OAM DMA Register (sprite data)
APU_SND_CHN     = $4015     ; Sound Channel Control
JOYPAD1         = $4016     ; Controller 1 Data

; ============================================================================
; ZERO PAGE VARIABLES ($00-$FF)
; ============================================================================
; General purpose variables
temp_ptr_lo     = $0000     ; Temporary pointer low byte
temp_ptr_hi     = $0001     ; Temporary pointer high byte / PPU control shadow
ppu_mask_copy   = $0002     ; PPU mask register copy
scroll_x        = $0003     ; Horizontal scroll position
scroll_y        = $0004     ; Vertical scroll position
temp_var_05     = $0005     ; Temporary variable
temp_var_06     = $0006     ; Temporary variable
temp_var_07     = $0007     ; Temporary variable
temp_var_08     = $0008     ; Temporary variable
temp_var_09     = $0009     ; Temporary variable

; Additional zero page variables
temp_var_11     = $0011
temp_var_12     = $0012
temp_var_13     = $0013
temp_var_14     = $0014
temp_var_15     = $0015

temp_var_17     = $0017
temp_var_18     = $0018
temp_var_19     = $0019
temp_var_1a     = $001A
temp_var_1b     = $001B
temp_var_1c     = $001C
temp_var_1d     = $001D
temp_var_1e     = $001E
temp_var_1f     = $001F
temp_var_20     = $0020
temp_var_21     = $0021
temp_var_22     = $0022
temp_var_23     = $0023
temp_var_24     = $0024
temp_var_25     = $0025
joypad1_state   = $0026     ; Joypad 1 current button state
joypad2_state   = $0027     ; Joypad 2 current button state
joypad1_prev    = $0028     ; Joypad 1 previous button state
joypad1_press   = $002A     ; Joypad 1 newly pressed buttons
temp_var_2b     = $002B
temp_var_2c     = $002C
temp_var_2d     = $002D
frame_counter   = $002E     ; Frame counter

temp_var_30     = $0030
game_state_var  = $0031     ; Game state variable
temp_var_32     = $0032
temp_var_33     = $0033
temp_var_34     = $0034
temp_var_35     = $0035
temp_var_36     = $0036
temp_var_37     = $0037
temp_var_38     = $0038
temp_var_39     = $0039
pause_flag      = $003A     ; Pause state flag
temp_var_3b     = $003B
temp_var_3c     = $003C
temp_var_3d     = $003D
temp_var_3e     = $003E

temp_var_42     = $0042

temp_var_44     = $0044
temp_var_45     = $0045
temp_var_46     = $0046

temp_var_49     = $0049
temp_var_4a     = $004A

temp_var_4e     = $004E

temp_var_52     = $0052

temp_var_54     = $0054
temp_var_55     = $0055
temp_var_56     = $0056
temp_var_57     = $0057
temp_var_58     = $0058
temp_var_59     = $0059
temp_var_5a     = $005A
temp_var_5b     = $005B
temp_var_5c     = $005C
temp_var_5d     = $005D
temp_var_5e     = $005E
temp_var_5f     = $005F
temp_var_60     = $0060
temp_var_61     = $0061
temp_var_62     = $0062
temp_var_63     = $0063
screen_mode     = $0064     ; Screen/game mode

temp_var_66     = $0066

game_var_68     = $0068     ; Game state variable
temp_var_69     = $0069
temp_var_6a     = $006A
temp_var_6b     = $006B
temp_var_6c     = $006C
temp_var_6d     = $006D
temp_var_6e     = $006E
temp_var_6f     = $006F
temp_var_70     = $0070

temp_var_72     = $0072
temp_var_73     = $0073
temp_var_74     = $0074

temp_var_76     = $0076
temp_var_77     = $0077
temp_var_78     = $0078
temp_var_79     = $0079
temp_var_7a     = $007A

temp_var_7f     = $007F

temp_var_81     = $0081

temp_var_83     = $0083

temp_var_85     = $0085

temp_var_87     = $0087
temp_var_88     = $0088
temp_var_89     = $0089
temp_var_8a     = $008A
temp_var_8b     = $008B
game_state_8c   = $008C     ; Game state flag
game_state_8d   = $008D     ; Game state flag
temp_var_8e     = $008E
temp_var_8f     = $008F
temp_var_90     = $0090
game_var_91     = $0091     ; Game variable
temp_var_92     = $0092
temp_var_93     = $0093

temp_var_99     = $0099

temp_var_9b     = $009B
temp_var_9c     = $009C
temp_var_9d     = $009D

temp_var_a0     = $00A0
temp_var_a1     = $00A1
temp_var_a2     = $00A2

temp_var_a5     = $00A5

temp_var_a9     = $00A9

temp_var_ab     = $00AB
temp_var_ac     = $00AC
temp_var_ad     = $00AD
temp_var_ae     = $00AE
temp_var_af     = $00AF
temp_var_b0     = $00B0
temp_var_b1     = $00B1
temp_var_b2     = $00B2
temp_var_b3     = $00B3
temp_var_b4     = $00B4
temp_var_b5     = $00B5
temp_var_b6     = $00B6
temp_var_b7     = $00B7
temp_var_b8     = $00B8
temp_var_b9     = $00B9

temp_var_bb     = $00BB
temp_var_bc     = $00BC
temp_var_bd     = $00BD

temp_var_c1     = $00C1

temp_var_c3     = $00C3
temp_var_c4     = $00C4
temp_var_c5     = $00C5

temp_var_c9     = $00C9
temp_var_ca     = $00CA
temp_var_cb     = $00CB
temp_var_cc     = $00CC

temp_var_ce     = $00CE
temp_var_cf     = $00CF
temp_var_d0     = $00D0

temp_var_d2     = $00D2
audio_track     = $00D3
temp_var_d4     = $00D4
temp_var_d5     = $00D5

temp_var_d7     = $00D7
temp_var_d8     = $00D8

; ============================================================================
; RAM VARIABLES ($0100-$07FF)
; ============================================================================
stack_base      = $0100     ; Hardware stack
temp_var_107    = $0107
temp_var_10d    = $010D
temp_var_190    = $0190
temp_var_194    = $0194
temp_var_1b0    = $01B0
temp_var_1b1    = $01B1
temp_var_1b2    = $01B2
temp_var_1b3    = $01B3
temp_var_1b4    = $01B4
temp_var_1b5    = $01B5
temp_var_1b6    = $01B6

; Sprite OAM buffer (Object Attribute Memory)
sprite_ram      = $0200     ; 256 bytes for sprite data
sprite_y_0      = $0200
sprite_tile_0   = $0201
sprite_attr_0   = $0202
sprite_x_0      = $0203
sprite_y_1      = $0204
sprite_tile_1   = $0205
temp_var_208    = $0208

; Additional RAM
ram_300         = $0300
sprite_flag     = $0300     ; Sprite update flag
temp_var_301    = $0301
temp_var_302    = $0302
temp_var_303    = $0303
temp_var_304    = $0304
temp_var_334    = $0334
ppu_update_flag = $0338     ; PPU update flag
temp_var_339    = $0339
temp_var_33a    = $033A
temp_var_33b    = $033B
temp_var_33c    = $033C
temp_var_33d    = $033D
temp_var_33e    = $033E
temp_var_33f    = $033F
temp_var_340    = $0340
temp_var_341    = $0341
temp_var_342    = $0342
temp_var_343    = $0343
temp_var_344    = $0344
temp_var_358    = $0358
temp_var_359    = $0359
temp_var_35a    = $035A
temp_var_35f    = $035F
temp_var_368    = $0368
temp_var_369    = $0369
temp_var_388    = $0388
temp_var_389    = $0389
temp_var_38a    = $038A
temp_var_38d = $038D
temp_var_38f = $038F
sprite_y_pos    = $0392     ; Sprite Y position
temp_var_398    = $0398
temp_var_399 = $0399
temp_var_39a = $039A
temp_var_39d = $039D
temp_var_39f = $039F
temp_var_3a8 = $03A8
temp_var_3aa = $03AA
temp_var_3af = $03AF
temp_var_3b8    = $03B8
temp_var_3b9 = $03B9
temp_var_400 = $0400
temp_var_471 = $0471
temp_var_4e2 = $04E2
temp_var_4e3 = $04E3
temp_var_522 = $0522
temp_var_540 = $0540
temp_var_559 = $0559
temp_var_568 = $0568
temp_var_5a4 = $05A4
temp_var_5a5 = $05A5
temp_var_5a6 = $05A6
temp_var_5a7 = $05A7
temp_var_5a8 = $05A8
temp_var_5ab = $05AB
temp_var_5ac = $05AC
temp_var_5ae = $05AE
temp_var_5af = $05AF
temp_var_5b0 = $05B0
temp_var_5b2 = $05B2
temp_var_5b4 = $05B4
temp_var_5b5 = $05B5
temp_var_5b6 = $05B6
temp_var_5b8 = $05B8
temp_var_5b9 = $05B9
temp_var_5ba = $05BA
temp_var_5bc = $05BC
temp_var_5be = $05BE
temp_var_5bf = $05BF
temp_var_5c2 = $05C2
temp_var_5c6 = $05C6
temp_var_5c7 = $05C7
temp_var_5c8 = $05C8
temp_var_5cc = $05CC
temp_var_5cd = $05CD
temp_var_5ce = $05CE
temp_var_5d3 = $05D3
temp_var_5d4 = $05D4
temp_var_5d9 = $05D9
temp_var_5da = $05DA
temp_var_5db = $05DB
temp_var_600 = $0600
temp_var_64c = $064C
temp_var_66a = $066A
temp_var_683 = $0683
temp_var_692 = $0692
temp_var_6ce = $06CE
temp_var_6cf = $06CF
temp_var_6d0 = $06D0
temp_var_6d1 = $06D1
temp_var_6d2 = $06D2
temp_var_6d8 = $06D8
temp_var_6de = $06DE
temp_var_6e2 = $06E2
temp_var_6e3 = $06E3
temp_var_6e4 = $06E4
temp_var_6e9 = $06E9
temp_var_6ea = $06EA
temp_var_700 = $0700
temp_var_701 = $0701
temp_var_702 = $0702
temp_var_703 = $0703
temp_var_707 = $0707
temp_var_708 = $0708
temp_var_709 = $0709
temp_var_70d = $070D
temp_var_711 = $0711
temp_var_712 = $0712
temp_var_713 = $0713
temp_var_714 = $0714
temp_var_715 = $0715
temp_var_719 = $0719
temp_var_71d = $071D
temp_var_721 = $0721
temp_var_725 = $0725
temp_var_729 = $0729
temp_var_72d = $072D
temp_var_731 = $0731
temp_var_739 = $0739
temp_var_73d = $073D
temp_var_741 = $0741
temp_var_745 = $0745
temp_var_749 = $0749
temp_var_74d = $074D
song_state = $07A1
temp_var_7a2 = $07A2
temp_var_7a3 = $07A3

; ============================================================================
; CODE SEGMENT - RESET HANDLER
; ============================================================================
.segment "CODE"

; ----------------------------------------------------------------------------
; Reset Vector - System initialization
; ----------------------------------------------------------------------------
Reset:
    sei                         ; Disable interrupts
    cld                         ; Clear decimal mode (not used on NES)
    
@wait_vblank1:
    lda PPU_STATUS              ; Wait for first VBlank
    bpl @wait_vblank1           ; Loop while bit 7 is clear
    
    lda #$00
    sta PPU_CTRL                ; Disable NMI and PPU
    sta PPU_MASK                ; Disable rendering
    
    ldx #$FF
    txs                         ; Initialize stack pointer to $01FF
    
    ; Clear zero page and most of RAM
    lda #$00
    sta temp_ptr_lo
    sta temp_ptr_hi
    ldy #$02                    ; Start at $0002
    ldx #$06                    ; Clear 6 pages
    
@clear_ram_loop:
    sta (temp_ptr_lo),Y         ; Clear byte at (zero page pointer + Y)
    iny
    cpx #$00
    bne @check_page_boundary
    cpy #$E0                    ; Stop at $06E0
    bcs @ram_clear_done
    
@check_page_boundary:
    cpy #$00
    bne @clear_ram_loop
    inc temp_ptr_hi             ; Move to next page
    dex
    bpl @clear_ram_loop
    
@ram_clear_done:
    sta temp_ptr_lo
    sta temp_ptr_hi
    
    ; Initialize APU
    lda #$00
    sta APU_SND_CHN             ; Disable all sound channels
    
    ; Initialize variables
    lda #$1E
    sta ppu_mask_copy           ; Set default PPU mask value
    
    lda #$88
    sta PPU_CTRL                ; Configure PPU control
    sta temp_ptr_hi             ; Save PPU control value
    
    lda #$01
    sta screen_mode             ; Set initial screen mode
    
@infinite_loop:
    inc temp_var_2c             ; Increment counter
    jmp @infinite_loop          ; Wait for NMI to take over

; ============================================================================
; NMI HANDLER - Called every VBlank (~60 times per second)
; ============================================================================
NMI:
    ; Disable NMI temporarily
    lda temp_ptr_hi
    and #$7F                    ; Clear NMI enable bit
    sta PPU_CTRL
    
    ; Check if special graphics update is needed
    lda temp_var_3b8
    beq @skip_special_gfx
    jsr update_special_graphics
    
@skip_special_gfx:
    ; Check sprite update mode
    lda sprite_flag
    beq @normal_sprite_update
    
    ; Special sprite update mode
    ldy #$00
    ldx #$00
    jsr update_sprites_special
    jmp @after_sprites
    
@normal_sprite_update:
    ; Normal sprite DMA transfer
    lda #$00
    sta OAM_ADDR                ; Reset OAM address
    lda #$02
    sta OAM_DMA                 ; Start DMA transfer from $0200
    
    ; Check if PPU update is needed
    lda ppu_update_flag
    beq @skip_ppu_update
    ldx #$00
    ldy #$00
    jsr update_ppu_data
    
@skip_ppu_update:
    ; Check nametable update flag
    lda temp_var_1b0
    beq @after_sprites
    jsr update_nametable
    
@after_sprites:
    ; Handle music/sound
    jsr _func_8963
    
    ; Update scroll registers
    lda scroll_x
    sta PPU_SCROLL
    lda scroll_y
    sta PPU_SCROLL
    
    ; Update PPU mask
    lda ppu_mask_copy
    sta PPU_MASK
    
    ; Read controller input
    jsr read_controllers
    
    ; Reset flags
    lda #$00
    sta sprite_flag
    sta temp_var_34
    
    ; Game logic dispatch
    lda screen_mode
    beq @game_logic_mode0
    
    ; Mode 1 logic
    jsr process_game_mode1
    jmp @after_game_logic
    
@game_logic_mode0:
    ; Mode 0 logic
    jsr clear_sprites
    jsr handle_game_input
    
@after_game_logic:
    ; Additional processing
    jsr process_game_state
    jsr update_animations
    jsr process_music_engine
    
    ; Restore PPU control
    lda PPU_STATUS              ; Reset PPU address latch
    lda temp_ptr_hi
    sta PPU_CTRL                ; Re-enable NMI
    
    inc frame_counter           ; Increment frame counter
    rti                         ; Return from interrupt

; ============================================================================
; GAME INPUT HANDLING
; ============================================================================
handle_game_input:
    ; Check for START button (pause)
    lda joypad1_press
    and #$10                    ; START button mask
    beq @no_pause_toggle
    
    ; Toggle pause state
    lda pause_flag
    eor #$01
    sta pause_flag
    jsr update_pause_display
    
@no_pause_toggle:
    ; Don't process game if paused
    lda pause_flag
    beq @not_paused
    rts
    
@not_paused:
    ; Check game state
    lda game_state_8c
    bne @handle_gameplay
    
    ; Menu/title screen logic
    lda #$00
    sta game_state_var
    jsr process_menu_state
    
    lda game_var_68
    bne @handle_gameplay
    jsr process_puzzle_input
    
@handle_gameplay:
    ; In-game logic
    lda game_var_68
    beq @check_game_over
    
    lda game_state_8d
    bne @check_game_over
    
    lda #$01
    sta game_state_var
    jsr process_gameplay
    
@check_game_over:
    ; Check if both states match (game over condition)
    lda game_state_8c
    beq @done
    cmp game_state_8d
    bne @done
    
    ; Trigger game over sequence
    jsr stop_all_music
    
    ldx #$0B                    ; Default next mode
    lda game_var_91
    bne @set_next_mode
    ldx #$06                    ; Alternate mode
    
@set_next_mode:
    stx screen_mode
    
@done:
    rts

; ============================================================================
; PAUSE DISPLAY UPDATE
; ============================================================================
update_pause_display:
    lda #$0C
    sta temp_var_11
    lda #$0A
    sta temp_var_12
    
    ; Check pause state
    lda pause_flag
    bne @paused
    
    ; Unpause - clear pause indicator
    sta temp_var_11
    
@paused:
    jsr update_display_elements
    
    ; Hide certain sprites when paused
    lda #$F8                    ; Off-screen Y position
    ldx #$02
    
@hide_sprite_loop:
    sta temp_var_398,X
    inx
    cpx #$0A
    bcc @hide_sprite_loop
    
    ; Show specific sprite during gameplay
    lda game_var_68
    beq @done
    lda #$28                    ; On-screen Y position
    sta sprite_y_pos
    
@done:
    rts

; ============================================================================
; CONTROLLER INPUT READING
; ============================================================================
read_controllers:
    ; Strobe controllers
    lda #$01
    sta JOYPAD1                 ; Begin read sequence
    lsr a                       ; A = 0
    tax                         ; X = 0 (controller 1)
    sta JOYPAD1                 ; End strobe
    
    jsr read_single_controller
    inx                         ; X = 1 (controller 2)

read_single_controller:
    lda #$00
    sta temp_var_05
    ldy #$08                    ; Read 8 buttons
    
@read_button_loop:
    pha
    lda JOYPAD1,X               ; Read button state
    sta temp_var_07
    lsr a
    lsr a
    rol temp_var_05             ; Shift into temp variable
    lsr temp_var_07
    pla
    rol a                       ; Shift into accumulator
    dey
    bne @read_button_loop
    
    ; Combine button states
    ora temp_var_05
    sta joypad1_state,X         ; Save current state
    
    ; Calculate newly pressed buttons
    eor joypad1_prev,X          ; XOR with previous state
    and joypad1_state,X         ; AND with current (edge detection)
    sta joypad1_press,X         ; Save newly pressed buttons
    
    ; Update previous state
    lda joypad1_state,X
    sta joypad1_prev,X
    rts

; ============================================================================
; GRAPHICS LOADING AND PPU UPDATES
; ============================================================================

; ----------------------------------------------------------------------------
; Load compressed graphics data to PPU
; Input: temp_var_11/12 = pointer to graphics data
; ----------------------------------------------------------------------------
load_graphics_data:
    lda #$00
    sta PPU_CTRL                ; Disable NMI
    sta PPU_MASK                ; Disable rendering
    
    ldy #$00
    lda PPU_STATUS              ; Reset PPU address latch
    
    ; Read and set PPU address (high byte)
    lda (temp_var_11),Y
    sta PPU_ADDR
    jsr increment_data_pointer
    
    ; Read and set PPU address (low byte)
    lda (temp_var_11),Y
    sta PPU_ADDR
    
@decode_loop:
    jsr increment_data_pointer
    lda (temp_var_11),Y
    bpl @copy_repeat_byte       ; Positive = repeat byte N times
    cmp #$FF                    ; $FF = end of data
    beq @done
    
    ; Negative value = RLE (Run Length Encoding)
    ; Copy N different bytes
    and #$7F                    ; Strip high bit to get count
    sta temp_var_07
    
@copy_bytes:
    jsr increment_data_pointer
    lda (temp_var_11),Y
    sta PPU_DATA
    dec temp_var_07
    bne @copy_bytes
    beq @decode_loop            ; Always branches
    
@copy_repeat_byte:
    ; Repeat same byte N times
    sta temp_var_07
    jsr increment_data_pointer
    lda (temp_var_11),Y
    
@repeat_loop:
    sta PPU_DATA
    dec temp_var_07
    bne @repeat_loop
    beq @decode_loop            ; Always branches
    
@done:
    rts

; ----------------------------------------------------------------------------
; Increment 16-bit data pointer
; ----------------------------------------------------------------------------
increment_data_pointer:
    inc temp_var_11
    bne @no_carry
    inc temp_var_12
@no_carry:
    rts

; ----------------------------------------------------------------------------
; Load palette data to PPU
; Input: temp_var_11/12 = pointer to palette data (32 bytes)
; ----------------------------------------------------------------------------
load_palette:
    lda PPU_STATUS              ; Reset PPU address latch
    lda #$3F                    ; Palette address high byte
    sta PPU_ADDR
    lda #$00                    ; Palette address low byte
    sta PPU_ADDR
    
    tay                         ; Y = 0
@copy_palette:
    lda (temp_var_11),Y
    sta PPU_DATA
    iny
    cpy #$20                    ; 32 bytes total
    bcc @copy_palette
    rts

; ----------------------------------------------------------------------------
; Jump table engine - indirect jump based on accumulator value
; Uses the return address on stack as the jump table base
; ----------------------------------------------------------------------------
jump_table_engine:
    asl a                       ; Multiply by 2 (word addresses)
    tay
    
    ; Pull return address from stack
    pla
    sta temp_var_13
    pla
    sta temp_var_14
    
    ; Read jump address from table
    iny                         ; Skip to next byte
    lda (temp_var_13),Y         ; Read low byte
    sta temp_var_11
    iny
    lda (temp_var_13),Y         ; Read high byte
    sta temp_var_12
    
    ; Jump to address
    jmp (temp_var_11)

; ----------------------------------------------------------------------------
; Clear sprite RAM - hide all sprites
; ----------------------------------------------------------------------------
clear_sprites:
    ldy #$00
    lda #$F8                    ; Off-screen Y position
@clear_loop:
    sta sprite_ram,Y            ; Set Y position
    iny
    iny
    iny
    iny                         ; Skip to next sprite (4 bytes each)
    bne @clear_loop
    rts

_func_81fa:  ; unreferenced?
  asl a
  asl a
  clc
  adc #$20
  ldx #$00
  sta PPU_ADDR
  stx PPU_ADDR
  ldy #$03
  lda #$ff
_label_820b:
  sta PPU_DATA
  dex
  bne _label_820b
  dey
  bpl _label_820b
  rts

; ----------------------------------------------------------------------------
; Update nametable from buffered data
; This handles multiple update regions stored in RAM
; ----------------------------------------------------------------------------
update_nametable:
    ldx #$00
    lda temp_var_1b0,X
    beq @done
    
@update_region:
    ; Load update parameters
    sta temp_var_12             ; High byte of PPU address
    lda temp_var_1b1,X
    sta temp_var_11             ; Low byte of PPU address
    lda temp_var_1b2,X
    sta temp_var_20             ; Width
    sta temp_var_21             ; Width copy
    lda temp_var_1b3,X
    sta temp_var_22             ; Height
    lda temp_var_1b4,X
    sta temp_var_05             ; Data pointer low
    lda temp_var_1b5,X
    sta temp_var_06             ; Data pointer high
    
    ldy #$00
    
@write_row:
    ; Set PPU address for this row
    lda PPU_STATUS
    lda temp_var_12
    sta PPU_ADDR
    lda temp_var_11
    sta PPU_ADDR
    
@write_tiles:
    lda (temp_var_05),Y
    sta PPU_DATA
    iny
    dec temp_var_20
    bne @write_tiles
    
    ; Move to next row
    dec temp_var_22
    beq @check_next_region
    
    ; Reset width and advance PPU address by 32
    lda temp_var_21
    sta temp_var_20
    lda temp_var_11
    clc
    adc #$20
    sta temp_var_11
    bcc @write_row
    inc temp_var_12
    jmp @write_row
    
@check_next_region:
    cpx #$06
    bcs @clear_flag
    ldx #$06
    lda temp_var_1b0,X
    bne @update_region
    
@clear_flag:
    lda #$00
    sta temp_var_1b0
    
@done:
    rts

_label_8279:
  sta temp_var_11
  lda a:temp_var_301,X
  sta temp_var_12
  lda a:temp_var_302,X
  sta temp_var_13
  lda a:temp_var_303,X
  sta temp_var_14
  inx
  inx
  inx
  inx
  lda temp_var_12
  cmp #$24
  beq update_sprites_special
  ldy #$02
  lda PPU_STATUS
  lda temp_var_12
  sta PPU_ADDR
  lda temp_var_11
  sta PPU_ADDR
  lda (temp_var_13),Y
  sta PPU_DATA
  iny
  lda (temp_var_13),Y
  sta PPU_DATA
  iny
  lda #$20
  clc
  adc temp_var_11
  sta temp_var_11
  lda temp_var_12
  adc #$00
  sta temp_var_12
  lda PPU_STATUS
  lda temp_var_12
  sta PPU_ADDR
  lda temp_var_11
  sta PPU_ADDR
  lda (temp_var_13),Y
  sta PPU_DATA
  iny
  lda (temp_var_13),Y
  sta PPU_DATA

update_sprites_special:
  lda a:sprite_flag,X
  bne _label_8279
  rts
_label_82da:
  sta temp_var_11
  lda a:temp_var_339,X
  sta temp_var_12
  lda a:temp_var_33a,X
  sta temp_var_13
  lda a:temp_var_33b,X
  sta temp_var_14
  txa
  clc
  adc #$04
  sta temp_var_22
  ldy #$00
  lda (temp_var_13),Y
  sta temp_var_21
  sta temp_var_1f
  iny
  lda (temp_var_13),Y
  sta temp_var_25
_label_82fe:
  ldx PPU_STATUS
  lda temp_var_12
  sta PPU_ADDR
  lda temp_var_11
  sta PPU_ADDR
_label_830b:
  iny
  lda (temp_var_13),Y
  sta PPU_DATA
  dec temp_var_1f
  bne _label_830b
  lda #$20
  clc
  adc temp_var_11
  sta temp_var_11
  lda temp_var_12
  adc #$00
  sta temp_var_12
  lda temp_var_21
  sta temp_var_1f
  dec temp_var_25
  bne _label_82fe
  ldx temp_var_22

update_ppu_data:
  lda a:ppu_update_flag,X
  bne _label_82da
  lda #$00
  sta temp_var_35
  sta a:ppu_update_flag
  rts

_func_8339:
  lda #$00
  ldx #$08
_label_833d:
  lsr temp_var_13
  bcc _label_8344
  clc
  adc temp_var_15
_label_8344:
  lsr a
  ror temp_var_17
  dex
  bne _label_833d
  sta temp_var_18
  rts

; ============================================================================
; SPRITE ANIMATION AND RENDERING
; ============================================================================

; ----------------------------------------------------------------------------
; Update sprite animations
; ----------------------------------------------------------------------------
update_animations:
    ldx #$00
    stx temp_var_1f
    
    ; Determine sprite direction based on frame counter
    lda frame_counter
    and #$01
    bne @reverse_order
    lda #$63                    ; Forward
    bne @set_direction
@reverse_order:
    lda #$01                    ; Reverse
@set_direction:
    sta temp_var_1e
    
@update_loop:
    lda temp_var_358,X
    beq @skip_sprite
    jsr update_single_sprite
    
@skip_sprite:
    inc temp_var_1f
    ldx temp_var_1f
    cpx #$10                    ; 16 sprites max
    bcc @update_loop
    rts

; ----------------------------------------------------------------------------
; Update a single sprite's animation frame
; Input: X = sprite index
; ----------------------------------------------------------------------------
update_single_sprite:
    ; Load sprite attributes
    lda temp_var_3a8,X          ; Sprite attributes
    sta temp_var_2d
    
    lda temp_var_1f
    tay
    asl a
    tax
    
    ; Load metasprite pointer
    lda temp_var_368,X
    sta temp_var_11
    lda temp_var_369,X
    sta temp_var_12
    
    ; Load sprite position
    lda temp_var_388,Y          ; X position
    sta temp_var_05
    sta temp_var_09
    lda temp_var_398,Y          ; Y position
    sta temp_var_07
    
    ; Read metasprite header
    ldy #$00
    lda (temp_var_11),Y         ; Pointer to frame data
    sta temp_var_13
    iny
    lda (temp_var_11),Y
    sta temp_var_14
    
    ldy #$00
    lda (temp_var_13),Y         ; Width in tiles
    sta temp_var_1b
    sta temp_var_1c
    iny
    lda (temp_var_13),Y         ; Height in tiles
    sta temp_var_1d
    iny
    
    sty temp_var_20
    sty temp_var_22
    
@render_tile_row:
    ; Calculate OAM offset
    lda temp_var_1e
    asl a
    asl a
    tax
    
    ; Write sprite data to OAM
    lda temp_var_07             ; Y position
    sta sprite_ram,X
    lda temp_var_09             ; X position
    sta sprite_x_0,X
    lda temp_var_2d             ; Attributes
    sta sprite_attr_0,X
    
    ; Handle horizontal flip
    lda temp_var_2d
    and #$40                    ; Check H-flip bit
    beq @no_hflip
    
    ; Flip: read tile from end
    lda temp_var_20
    clc
    adc temp_var_1c
    tay
    dey
    lda (temp_var_13),Y
    sta sprite_tile_0,X
    jmp @after_tile
    
@no_hflip:
    ; Normal: read tile sequentially
    ldy temp_var_22
    lda (temp_var_13),Y
    sta sprite_tile_0,X
    inc temp_var_22
    
@after_tile:
    ; Advance X position
    lda temp_var_09
    clc
    adc #$08                    ; Next tile (8 pixels)
    sta temp_var_09
    
    ; Update sprite index
    lda frame_counter
    and #$01
    bne @increment_sprite
    dec temp_var_1e
    jmp @check_row_complete
@increment_sprite:
    inc temp_var_1e
    
@check_row_complete:
    dec temp_var_1c
    bne @render_tile_row
    
    ; Move to next row
    dec temp_var_1d
    beq @done
    
    lda temp_var_1b
    sta temp_var_1c
    clc
    adc temp_var_20
    sta temp_var_20
    sta temp_var_22
    
    ; Advance Y position
    lda temp_var_07
    clc
    adc #$08
    sta temp_var_07
    
    ; Reset X position
    lda temp_var_05
    sta temp_var_09
    jmp @render_tile_row
    
@done:
    rts

process_game_state:
  ldx #$00
  stx temp_var_1b
_label_8419:
  lda a:temp_var_358,X
  beq _label_8421
  jsr _func_845e
_label_8421:
  inc temp_var_1b
  ldx temp_var_1b
  cpx #$10
  bcc _label_8419
  rts

_func_842A: ; unreferenced?
  lda frame_counter
  and #$3F
  bne _label_845d
  lda a:temp_var_368,X
  sta temp_var_11
  lda a:temp_var_369,X
  sta temp_var_12
  ldy #$02
  lda (temp_var_11),Y
  cmp #$FF
  bne _label_844b
  iny
  lda (temp_var_11),Y
  iny
  cmp #$FF
  bne _label_844b
  rts
_label_844b:
  lda temp_var_1b
  asl a
  tax
  lda a:temp_var_368,X
  clc
  adc #$02
  sta a:temp_var_368,X
  bcc _label_845d
  inc a:temp_var_369,X
_label_845d:
  rts

_func_845e:
  lda frame_counter
  and #$0F
  bne _label_845d
  lda temp_var_1b
  asl a
  tax
  lda a:temp_var_368,X
  clc
  adc #$02
  sta a:temp_var_368,X
  bcc _label_8476
  inc a:temp_var_369,X
_label_8476:
  lda a:temp_var_368,X
  sta temp_var_11
  lda a:temp_var_369,X
  sta temp_var_12
  ldy #$00
  lda (temp_var_11),Y
  cmp #$FF
  bne _label_84a3
  iny
  lda (temp_var_11),Y
  iny
  cmp #$FF
  bne _label_84a3
  ldy temp_var_1b
  lda a:temp_var_358,Y
  asl a
  tay
  lda a:_data_f21b,Y
  sta a:temp_var_368,X
  lda a:_data_f21b+1,Y
  sta a:temp_var_369,X
_label_84a3:
  rts

_func_84A4: ; unreferenced?
  ldx #$00
_label_8697:
  lda a:temp_var_358,X
  beq _label_86a2
  inx
  cpx #$10
  bcc _label_8697
  rts
_label_86a2:
  ldy temp_var_11
  lda a:_data_f20e_indexed,Y
  sta a:temp_var_3a8,X
  lda temp_var_11
  sta a:temp_var_358,X
  stx temp_var_1b
  asl a
  tay
  lda a:_data_f235,Y
  sta a:temp_var_388,X
  lda a:_data_f235+1,Y
  sta a:temp_var_398,X
  txa
  asl a
  tax
  lda a:_data_f21b,Y
  sta a:temp_var_368,X
  lda a:_data_f21b+1,Y
  sta a:temp_var_369,X
  rts

_func_84de:
  lda #$40
  sta temp_var_1f
  ldy #$00
_label_84e4:
  lda (temp_var_11),Y
  sta a:temp_var_4e2,Y
  iny
  dec temp_var_1f
  bne _label_84e4
  rts

update_special_graphics:
  ldy PPU_STATUS
  ldy #$23
  ldx #$00
_label_84f6:
  sty PPU_ADDR
  sta PPU_ADDR
  inx
  lda a:temp_var_3b8,X
  sta PPU_DATA
  inx
  lda a:temp_var_3b8,X
  bne _label_84f6
  lda #$00
  sta a:temp_var_3b8
  sta temp_var_36
  rts

_func_8511:
  ; ------------------------------------------------------------
  ; Load and (conditionally) adjust a 16-bit table entry from _data_fb83
  ;
  ; Input:
  ;   A = index (byte) into _data_fb83 (0..n)
  ;
  ; Output:
  ;   temp_var_20 = saved original index
  ;   temp_var_19 = LOW  byte of the selected 16-bit entry
  ;   temp_var_1a = HIGH byte of the selected 16-bit entry
  ;
  ; Description:
  ;   The table at _data_fb83 stores little-endian 16-bit addresses (low,high).
  ;   We multiply the index by two (ASL) to compute the word offset and
  ;   load the two bytes. Callers then use temp_var_19/1a as a 16-bit value
  ;   (e.g., they are written into sprite_flag for sprite placement).
  ;
  ;   After loading, the low byte is conditionally adjusted based on game
  ;   state:
  ;     - If game_var_68 == 0: return unchanged.
  ;     - Else if game_state_var == 0: subtract 2 from the LOW byte
  ;       (dec twice) -- note this only changes the low byte (no borrow to
  ;       the high byte).
  ;     - Otherwise: add $0E to the LOW byte (again, low-byte only).
  ;   The adjusted pair is left in temp_var_19/1a for callers.
  ; ------------------------------------------------------------
  sta temp_var_20
  asl a
  tax
  lda a:_data_fb83,X
  sta temp_var_19
  lda a:_data_fb83+1,X
  sta temp_var_1a
  lda game_var_68
  bne _label_8524
  rts
_label_8524:
  lda game_state_var
  bne _label_852d
  dec temp_var_19
  dec temp_var_19
  rts
_label_852d:
  lda temp_var_19
  clc
  adc #$0E
  sta temp_var_19
  rts

_func_8535:
  lda temp_var_19
  asl a
  lda temp_var_1a
  rol a
  rol a
  rol a
  rol a
  and #$38
  sta temp_var_20
  lda temp_var_19
  ror a
  ror a
  and #$07
  ora temp_var_20
  tay
  clc
  adc #$C0
  ldx temp_var_36
  sta a:temp_var_3b8,X
  inc temp_var_36
  lda temp_var_19
  and #$42
  ror a
  ror a
  ror a
  ror a
  ror a
  sta temp_var_20
  lda temp_var_19
  ror a
  and #$01
  ora temp_var_20
  and #$03
  tax
  lda temp_var_1b
  cmp #$03
  bcc _label_8586
  lda a:temp_var_4e2,Y
  ora a:_data_85a0_indexed,X
  sta a:temp_var_4e2,Y
  ldx temp_var_36
  sta a:temp_var_3b8,X
  lda #$00
  sta a:temp_var_3b9,X
  inc temp_var_36
  rts
_label_8586:
  lda a:temp_var_4e2,Y
  and a:_data_859c_indexed,X
  sta a:temp_var_4e2,Y
  ldx temp_var_36
  sta a:temp_var_3b8,X
  lda #$00
  sta a:temp_var_3b9,X
  inc temp_var_36
  rts

_data_859c_indexed:
.byte $fc, $f3, $cf, $3f

_data_85a0_indexed:
.byte $03, $0c, $30, $c0

_func_85a4:
  lda frame_counter
  adc temp_var_2c
  adc temp_var_39
  and #$3F
  sta temp_var_39
  rts

update_display_elements:
  lda temp_var_11
  tay
  ldx temp_var_12
  sta a:temp_var_358,X
  lda a:_data_f20e_indexed,Y
  sta a:temp_var_3a8,X
  tya
  asl a
  tay
  lda a:_data_f235,Y
  sta a:temp_var_388,X
  lda a:_data_f235+1,Y
  sta a:temp_var_398,X
  txa
  asl a
  tax
  lda a:_data_f21b,Y
  sta a:temp_var_368,X
  lda a:_data_f21b+1,Y
  sta a:temp_var_369,X
  rts

_func_85dc:
  ldx temp_var_34
  lda temp_var_19
  sta a:sprite_flag,X
  inx
  lda temp_var_1a
  sta a:sprite_flag,X
  inx
  lda temp_var_17
  sta a:sprite_flag,X
  inx
  lda temp_var_18
  sta a:sprite_flag,X
  inx
  stx temp_var_34
  rts

_func_85f9:
  ldx temp_var_35
  lda temp_var_19
  sta a:ppu_update_flag,X
  inx
  lda temp_var_1a
  sta a:ppu_update_flag,X
  inx
  lda temp_var_17
  sta a:ppu_update_flag,X
  inx
  lda temp_var_18
  sta a:ppu_update_flag,X
  inx
  stx temp_var_35
  rts

process_game_mode1:
  inc temp_var_6c
  lda screen_mode
  bne _label_861d
_label_861c:
  rts
_label_861d:
  jsr update_animations
  lda screen_mode
  jsr jump_table_engine

  .word _label_861c
  .word _label_863d
  .word _label_881f
  .word _label_accc
  .word _label_aa20
  .word _label_ad55
  .word _label_89bb
  .word _label_8d5f
  .word _label_88d1
  .word _label_9180
  .word _label_9286
  .word _label_9293

_label_863d:
  lda temp_var_66
  bne _label_867f
  lda #$02
  jsr clear_sprites
  inc temp_var_66
  lda #$00
  sta temp_var_6c
  sta temp_var_6d
  jsr _func_8d9e
  jsr _func_8dbe
  lda temp_ptr_lo
  bne _label_865f
  jsr _func_8c3e
  lda #$01
  sta temp_ptr_lo
_label_865f:
  ldx #$00
  jsr _func_8d8f
  lda temp_ptr_hi
  and #$88
  ora #$88
  sta temp_ptr_hi
  lda #$02

_func_866e:
  sta a:audio_track
  lda #$01
  sta a:temp_var_d2
  jsr _func_de4b
  lda #$00
  sta a:temp_var_d2
  rts
_label_867f:
  jsr _func_init_wave
  jsr _func_86fe
  lda joypad1_press
  and #$10
  beq _label_8694
  inc screen_mode
  lda #$00
  sta temp_var_66
  sta a:temp_var_1b0
_label_8694:
  rts

_func_8695:  ; unreferenced?
  ora (temp_var_a5,x)
  rol a
  and #$10
  beq _label_86b3
  lda #$00
  sta temp_var_66
  sta screen_mode
  sta a:temp_var_1b0
  sta PPU_CTRL
  sta PPU_MASK
  lda $01
  and #$88
  ora #$88
  sta temp_ptr_hi
_label_86b3:
  rts

_data_86b4_indexed:
.byte $00, $01, $03, $04, $06, $07, $08, $0a, $0b, $0c, $0e, $0f, $10, $11, $12, $13
.byte $15, $16, $17, $18, $19, $19, $1a, $1b, $1c, $1c, $1d, $1e, $1e, $1f, $1f, $1f
.byte $20, $20, $20, $20, $20

_data_86d9_indexed:
.byte $60, $60, $60, $5f, $5f, $5e, $5d, $5c, $5a, $59, $57, $55, $53, $51, $4f, $4c
.byte $4a, $47, $44, $41, $3e, $3a, $37, $34, $30, $2c, $29, $25, $21, $1d, $19, $15
.byte $11, $0d, $08, $04, $00

_func_86fe:
  jsr _func_8738
  lda #$BF
  sta temp_var_20
  lda temp_var_6f
  cmp #$02
  bcs _label_8718
  lda #$22
  sta temp_var_23
  lda #$F8
  sta a:sprite_ram
  ldx #$FC
  bne _label_8723
_label_8718:
  lda #$02
  sta temp_var_23
  lda #$F8
  sta a:$02FC
  ldx #$00
_label_8723:
  lda temp_var_20
  sta a:sprite_tile_0,X
  lda temp_var_23
  sta a:sprite_attr_0,X
  lda temp_var_22
  sta a:sprite_ram,X
  lda temp_var_21
  sta a:sprite_x_0,X
  rts

_func_8738:
  lda temp_var_6f
  jsr jump_table_engine

  .word _label_8745
  .word _label_8764
  .word _label_8782
  .word _label_87a1

_label_8745:
  ldx temp_var_6e
  lda #$58
  sec
  sbc a:_data_86b4_indexed,X
  sta temp_var_22
  lda a:_data_86d9_indexed,X
  clc
  adc #$80
  sta temp_var_21
  inc temp_var_6e
  lda temp_var_6e
  cmp #$25
  bcc _label_8763
  dec temp_var_6e
  inc temp_var_6f
_label_8763:
  rts
_label_8764:
  dec temp_var_6e
  bpl _label_876f
  inc temp_var_6f
  lda #$00
  sta temp_var_6e
  rts
_label_876f:
  ldx temp_var_6e
  lda #$58
  sec
  sbc a:_data_86b4_indexed,X
  sta temp_var_22
  lda #$80
  sec
  sbc a:_data_86d9_indexed,X
  sta temp_var_21
  rts
_label_8782:
  ldx temp_var_6e
  lda a:_data_86b4_indexed,X
  clc
  adc #$58
  sta temp_var_22
  lda #$80
  sec
  sbc a:_data_86d9_indexed,X
  sta temp_var_21
  inc temp_var_6e
  lda temp_var_6e
  cmp #$25
  bcc _label_87a0
  inc temp_var_6f
  dec temp_var_6e
_label_87a0:
  rts
_label_87a1:
  dec temp_var_6e
  bpl _label_87ac
  lda #$00
  sta temp_var_6e
  sta temp_var_6f
  rts
_label_87ac:
  ldx temp_var_6e
  lda #$58
  clc
  adc a:_data_86b4_indexed,X
  sta temp_var_22
  lda a:_data_86d9_indexed,X
  clc
  adc #$80
  sta temp_var_21
  rts

_func_init_wave:
  lda temp_var_6c
  and #$07
  bne @init_wave_skip
  lda temp_var_6d
  cmp #$04
  bcs @init_wave_skip
  lda #$3F
  sta a:temp_var_1b0
  lda #$00
  sta a:temp_var_1b1
  lda #$10
  sta a:temp_var_1b2
  lda #$01
  sta a:temp_var_1b3
  lda temp_var_6d
  asl a
  tax
  lda a:_data_bf93,X
  sta a:temp_var_1b4
  lda a:_data_bf93+1,X
  sta a:temp_var_1b5
  lda #$00
  sta a:temp_var_1b6
  sta temp_var_6c
  inc temp_var_6d
@init_wave_skip:
  lda temp_var_6c
  cmp #$20
  bcc @init_wave_done
  lda temp_var_6d
  cmp #$05
  bcs @init_wave_done
  inc temp_var_6d
  ldx #$0C
@init_wave_copy:
  lda a:_data_init_wave_table,X
  sta a:temp_var_1b0,X
  dex
  bpl @init_wave_copy
@init_wave_done:
  rts

_data_init_wave_table:
.byte $23, $08, $0f, $01, $fa, $90, $22, $e6, $13, $01, $09, $91, $00

_label_881f:
  lda temp_var_66
  beq _label_8826
  jmp _label_88af
_label_8826:
  sta game_state_8c
  sta game_state_8d
  tax
  ldy #$14
_label_882d:
  sta a:temp_var_5ac,X
  inx
  dey
  bne _label_882d
  jsr _func_a85e
  jsr _func_99d1
  inc temp_var_66
  lda #$02
  jsr clear_sprites
  ldx #$00
  lda #$03
_label_8845:
  sta a:sprite_attr_0,X
  inx
  inx
  inx
  inx
  bne _label_8845
  jsr _func_911c
  ldx #$00
  jsr _func_8d8f
  ldx #$02
  lda a:_data_be52,X
  sta temp_var_11
  lda a:_data_be52+1,X
  sta temp_var_12
  jsr load_palette
  lda PPU_STATUS
  lda #$27
  sta PPU_ADDR
  lda #$F0
  sta PPU_ADDR
  ldy #$10
  lda #$FF
_label_8876:
  sta PPU_DATA
  dey
  bne _label_8876
  lda #$00
  tax
_label_887f:
  sta a:temp_var_600,X
  inx
  bne _label_887f
  ldx #$00
_label_8887:
  lda a:_data_8f7c_indexed,X
  sta a:sprite_ram,X
  inx
  cpx #$14
  bcc _label_8887
  lda #$EF
  sta scroll_y
  lda temp_ptr_hi
  and #$F7
  ora #$19
  sta temp_ptr_hi
  lda #$03
  sta game_var_91
  lda #$00
  sta temp_var_56
  ldx #$00
  stx temp_var_57
  lda #$05
  jmp _func_866e
_label_88af:
  jsr _func_8dcf
  jsr _func_8e10
  jsr _func_8e67
  lda joypad1_press
  and #$10
  beq _label_88c4
  inc screen_mode
  lda #$00
  sta temp_var_66
_label_88c4:
  rts

_data_88c5_indexed:
.byte $81, $99, $81, $99, $81, $99, $81, $99, $81, $99, $81, $99

_label_88d1:
  lda temp_var_66
  bne _label_890e
  sta temp_var_6c
  sta temp_var_89
  inc temp_var_66
  jsr clear_sprites
  lda temp_var_88
  clc
  adc #$04
  jsr _func_8d9e
  lda temp_var_88
  lsr a
  clc
  adc #$02
  tax
  jsr _func_8d8f
  jsr _func_8ee3
  ldx temp_var_88
  lda temp_ptr_hi
  and #$E6
  ora a:_data_88c5_indexed,X
  sta temp_ptr_hi
  lda #$00
  sta scroll_x
  sta scroll_y
  lda temp_var_90
  bne _label_890d
  lda #$04
  jsr _func_866e
_label_890d:
  rts
_label_890e:
  jsr _func_898b
  lda temp_var_90
  bne _label_8948
  lda joypad1_press
  and #$C0
  bne _label_8921
  lda temp_var_2b
  and #$C0
  beq _label_8947
_label_8921:
  lda #$00
  sta temp_var_66
  sta a:temp_var_1b0
  lda #$04
  sta screen_mode
  lda #$00
  sta temp_var_5b
  sta temp_var_5a
  lda temp_var_88
  cmp #$0B
  bne _label_893f
  inc temp_var_90
  lda #$06
  sta screen_mode
  rts
_label_893f:
  lda temp_ptr_hi
  and #$88
  ora #$88
  sta temp_ptr_hi
_label_8947:
  rts
_label_8948:
  inc temp_var_8e
  bne _label_8962
  lda #$00
  sta temp_var_66
  inc temp_var_88
  lda temp_var_88
  cmp #$0C
  bcc _label_8962
  lda #$07
  sta screen_mode
  lda #$00
  sta temp_var_66
  sta temp_var_90
_label_8962:
  rts

_func_8963:
  ldy #$00
  lda temp_var_8b
  beq _label_8988
_label_8969:
  lda (temp_var_8a),Y
  beq _label_8988
  sta PPU_ADDR
  iny
  lda (temp_var_8a),Y
  sta PPU_ADDR
  iny
  lda (temp_var_8a),Y
  sta temp_var_11
  iny
_label_897c:
  lda (temp_var_8a),Y
  sta PPU_DATA
  iny
  dec temp_var_11
  bne _label_897c
  beq _label_8969
_label_8988:
  sta temp_var_8b
  rts

_func_898b:
  lda temp_var_88
  asl a
  tax
  lda a:_data_bac0,X
  sta temp_var_11
  lda a:_data_bac0+1,X
  sta temp_var_12
  ldy temp_var_89
  lda (temp_var_11),Y
  bne _label_89a5
  ldy #$00
  sty temp_var_89
  lda (temp_var_11),Y
_label_89a5:
  cmp temp_var_6c
  bcs _label_89ba
  lda #$00
  sta temp_var_6c
  iny
  lda (temp_var_11),Y
  sta temp_var_8a
  iny
  lda (temp_var_11),Y
  sta temp_var_8b
  iny
  sty temp_var_89
_label_89ba:
  rts
_label_89bb:
  lda temp_var_66
  bne _label_8a24
  lda temp_var_90
  bne _label_89cc
  inc temp_var_8e
  lda temp_var_8e
  cmp #$70
  bcs _label_89cc
  rts
_label_89cc:
  lda #$00
  sta temp_var_8e
  inc temp_var_66
  lda #$02
  jsr clear_sprites
  jsr _func_8ee3
  ldx #$00
  jsr _func_8d8f
  lda #$02
  jsr _func_8d9e
  lda temp_ptr_hi
  and #$E6
  ora #$19
  sta temp_ptr_hi
  lda #$00
  sta scroll_x
  sta scroll_y
  jsr _func_8a56
  lda #$00
  tax
  sta temp_var_70
  sta z:$71
  sta temp_var_83
  sta z:$84
  sta temp_var_85
  sta z:$86
  sta z:$7E
_label_8a06:
  lda a:_data_8c39_indexed,X
  sta temp_var_74,X
  sta temp_var_7a,X
  inx
  cpx #$04
  bcc _label_8a06
  lda temp_var_76
  sta temp_var_7f
  sta z:$80
  lda temp_var_77
  sta temp_var_81
  sta z:$82
  lda #$03
  jsr _func_866e
  rts
_label_8a24:
  jsr _func_8c4c
  lda joypad1_press
  and #$10
  beq _label_8a46
  lda #$02
  sta screen_mode
  lda #$00
  sta temp_var_66
  lda temp_var_90
  beq _label_8a46
  lda #$08
  sta screen_mode
  lda #$00
  sta temp_var_88
  lda #$04
  jsr _func_866e
_label_8a46:
  rts

_func_8a47:
  ldy #$00
_label_8a49:
  lda a:temp_var_5ac,X
  sta a:temp_var_190,Y
  inx
  iny
  cpy #$0A
  bcc _label_8a49
  rts

_func_8a56:
  ldx #$0A
  stx temp_var_87
  jsr _func_8a47
  jsr _func_8a89
  ldx #$00
  stx temp_var_87
  jsr _func_8a47
  jsr _func_8a89
  lda temp_var_1d
  cmp temp_var_1c
  bcc _label_8a88
  inc temp_var_1d
  lda temp_var_79
  clc
  adc #$40
  sta temp_var_79
  lda temp_var_78
  adc #$00
  sta temp_var_78
  lda #$0D
  clc
  adc a:temp_var_5da
  sta a:temp_var_5da
_label_8a88:
  rts

_func_8a89:
  ldy #$00
  sty temp_var_11
_label_8a8d:
  ldx #$00
_label_8a8f:
  lda a:temp_var_194,X
  beq _label_8aac
  lda a:temp_var_107,Y
  bmi _label_8aa6
  lda a:temp_var_194,X
  clc
  adc #$30
  cmp a:temp_var_107,Y
  beq _label_8ab5
  bcc _label_8abb
_label_8aa6:
  jsr _func_8b8e
  jmp _label_8ade
_label_8aac:
  lda a:temp_var_107,Y
  bmi _label_8ab5
  cmp #$31
  bcs _label_8abb
_label_8ab5:
  inx
  iny
  cpx #$06
  bcc _label_8a8f
_label_8abb:
  inc temp_var_11
  lda temp_var_11
  cmp #$0A
  bcs _label_8ad3
  lda temp_var_11
  sta temp_var_13
  lda #$0D
  sta temp_var_15
  jsr _func_8339
  ldy temp_var_17
  jmp _label_8a8d
_label_8ad3:
  ldx temp_var_87
  beq _label_8adc
  sta temp_var_1d
  jmp _label_8ade
_label_8adc:
  sta temp_var_1c
_label_8ade:
  ldy #$00
  sty temp_var_25
_label_8ae2:
  ldx #$00
  stx temp_var_24
_label_8ae6:
  txa
  asl a
  tax
  lda a:_data_8b82_indexed,X
  sta temp_var_07
  lda a:_data_8b83_indexed,X
  sta temp_var_08
  lda temp_var_25
  sta temp_var_13
  lda #$40
  sta temp_var_15
  jsr _func_8339
  lda temp_var_07
  clc
  adc temp_var_17
  sta a:temp_var_1b1
  lda temp_var_08
  adc temp_var_18
  sta a:temp_var_1b0
  lda temp_var_87
  beq _label_8b19
  ldy temp_var_25
  cpy temp_var_1d
  bne _label_8b37
  beq _label_8b1f
_label_8b19:
  ldy temp_var_25
  cpy temp_var_1c
  bne _label_8b37
_label_8b1f:
  ldx temp_var_24
  bne _label_8b37
  lda temp_var_87
  bne _label_8b2b
  ldx #$00
  beq _label_8b2d
_label_8b2b:
  ldx #$06
_label_8b2d:
  lda a:temp_var_1b0
  sta temp_var_72,X
  lda a:temp_var_1b1
  sta temp_var_73,X
_label_8b37:
  ldx temp_var_24
  lda a:_data_8b88_indexed,X
  sta temp_var_1b
  lda a:_data_8b8b_indexed,X
  sta a:temp_var_1b2
  lda #$01
  sta a:temp_var_1b3
  lda temp_var_25
  sta temp_var_13
  lda #$0D
  sta temp_var_15
  jsr _func_8339
  lda #$00
  clc
  adc temp_var_17
  adc temp_var_1b
  sta a:temp_var_1b4
  lda #$01
  sta a:temp_var_1b5
  lda #$00
  sta a:temp_var_1b6
  jsr update_nametable
  inc temp_var_24
  ldx temp_var_24
  cpx #$03
  bcs _label_8b76
  jmp _label_8ae6
_label_8b76:
  inc temp_var_25
  lda temp_var_25
  cmp #$0A
  bcs _label_8b81
  jmp _label_8ae2
_label_8b81:
  rts

_data_8b82_indexed:
.byte $27

_data_8b83_indexed:
.byte $25, $2e, $25, $35, $25

_data_8b88_indexed:
.byte $00, $03, $07

_data_8b8b_indexed:
.byte $03, $04, $06

_func_8b8e:
  ldx temp_var_87
  beq _label_8b99
  lda temp_var_11
  sta temp_var_1d
  jmp _label_8b9d
_label_8b99:
  lda temp_var_11
  sta temp_var_1c
_label_8b9d:
  sta temp_var_1e
  sta temp_var_13
  lda #$0D
  sta temp_var_15
  jsr _func_8339
  lda temp_var_17
  sta temp_var_22
  ldx temp_var_22
  cpx #$75
  bcs _label_8bd9
  ldx #$08
  stx temp_var_11
_label_8bb6:
  lda temp_var_11
  sta temp_var_13
  lda #$0D
  sta temp_var_15
  jsr _func_8339
  ldx temp_var_17
  cpx temp_var_22
  bcc _label_8bd9
  ldy #$00
_label_8bc9:
  lda a:stack_base,X
  sta a:temp_var_10d,X
  inx
  iny
  cpy #$0D
  bcc _label_8bc9
  dec temp_var_11
  bpl _label_8bb6
_label_8bd9:
  ldx #$00
  lda temp_var_87
  beq _label_8be0
  inx
_label_8be0:
  lda temp_var_22
  sta a:temp_var_5d9,X
  tax
  lda #$FF
  sta a:stack_base,X
  inx
  sta a:stack_base,X
  inx
  sta a:stack_base,X
  inx
  ldy #$00
  sty temp_var_1e
_label_8bf8:
  lda a:temp_var_190,Y
  bne _label_8c05
  lda temp_var_1e
  bne _label_8c05
  lda #$FF
  bne _label_8c0d
_label_8c05:
  inc temp_var_1e
  lda a:temp_var_190,Y
  clc
  adc #$30
_label_8c0d:
  sta a:stack_base,X
  inx
  iny
  cpy #$04
  bcc _label_8bf8
  ldy #$00
  sty temp_var_1e
_label_8c1a:
  lda a:temp_var_194,Y
  bne _label_8c27
  lda temp_var_1e
  bne _label_8c27
  lda #$FF
  bne _label_8c2f
_label_8c27:
  inc temp_var_1e
  lda a:temp_var_194,Y
  clc
  adc #$30
_label_8c2f:
  sta a:stack_base,X
  inx
  iny
  cpy #$06
  bcc _label_8c1a
  rts

_data_8c39_indexed:
.byte $01, $01, $df, $90, $ff

_func_8c3e:
  ldx #$00
_label_8c40:
  lda a:_data_905d_indexed,X
  sta a:stack_base,X
  inx
  cpx #$82
  bcc _label_8c40
_label_8c4b:
  rts

_func_8c4c:
  lda game_var_68
  beq _label_8c59
  ldy #$06
  sta temp_var_87
  ldx #$01
  jsr _func_8c5f
_label_8c59:
  ldx #$00
  ldy #$00
  sta temp_var_87

_func_8c5f:
  lda temp_var_1c,X
  cmp #$0A
  bcs _label_8c4b
  lda temp_var_70,X
  cmp #$03
  bcs _label_8c4b
  lda temp_var_85,X
  beq _label_8c7c
  lda a:temp_var_73,Y
  clc
  adc #$01
  sta a:temp_var_73,Y
  lda #$00
  sta temp_var_85,X
_label_8c7c:
  lda temp_var_6c
  and #$07
  bne _label_8c9f
  lda temp_var_6c
  and #$08
  beq _label_8c95
  lda #$3D
  sta a:temp_var_76,Y
  lda #$8C
  sta a:temp_var_77,Y
  jmp _label_8c9f
_label_8c95:
  lda temp_var_7f,X
  sta a:temp_var_76,Y
  lda temp_var_81,X
  sta a:temp_var_77,Y
_label_8c9f:
  lda joypad1_press,X
  and #$80
  beq _label_8ce0
  inc temp_var_70,X
  inc temp_var_85,X
  lda temp_var_7f,X
  sta a:temp_var_76,Y
  lda temp_var_81,X
  sta a:temp_var_77,Y
  lda #$DF
  sta temp_var_7f,X
  lda #$90
  sta temp_var_81,X
  tya
  pha
  lda a:temp_var_5d9,X
  clc
  adc temp_var_70,X
  tay
  dey
  lda temp_var_83,X
  clc
  adc #$41
  cmp #$5B
  bne _label_8cd0
  lda #$40
_label_8cd0:
  sta a:stack_base,Y
  pla
  tay
  lda #$00
  sta temp_var_83,X
  lda #$05
  sta temp_var_6c
  jmp _label_8d38
_label_8ce0:
  lda joypad1_press,X
  and #$01
  beq _label_8d03
  inc temp_var_7f,X
  bne _label_8cec
  inc temp_var_81,X
_label_8cec:
  inc temp_var_83,X
  lda temp_var_83,X
  cmp #$1B
  bcc _label_8d2c
  lda #$DF
  sta temp_var_7f,X
  lda #$90
  sta temp_var_81,X
  lda #$00
  sta temp_var_83,X
  jmp _label_8d2c
_label_8d03:
  lda joypad1_press,X
  and #$02
  beq _label_8d2c
  lda temp_var_7f,X
  sec
  sbc #$01
  sta temp_var_7f,X
  bcs _label_8d14
  dec temp_var_81,X
_label_8d14:
  dec temp_var_83,X
  bpl _label_8d2c
  lda #$1A
  sta temp_var_83,X
  lda #$DF
  clc
  adc #$1A
  sta temp_var_7f,X
  lda #$90
  adc #$00
  sta temp_var_81,X
  jmp _label_8d2c
_label_8d2c:
  lda temp_var_70,X
  cmp #$03
  bcc _label_8d38
  lda #$00
  sta a:temp_var_1b0
  rts
_label_8d38:
  ldx #$00
  lda temp_var_1c
  cmp #$0A
  bcs _label_8d4b
_label_8d40:
  lda temp_var_72,X
  sta a:temp_var_1b0,X
  inx
  cpx #$0C
  bcc _label_8d40
  rts
_label_8d4b:
  ldy #$06
_label_8d4d:
  lda a:temp_var_72,Y
  sta a:temp_var_1b0,X
  iny
  inx
  cpx #$06
  bcc _label_8d4d
  lda #$00
  sta a:temp_var_1b0,X
  rts
_label_8d5f:
  lda temp_var_66
  bne _label_8d85
  inc temp_var_66
  lda #$02
  jsr clear_sprites
  jsr _func_8ee3
  ldx #$00
  jsr _func_8d8f
  lda #$03
  jsr _func_8d9e
  lda temp_ptr_hi
  and #$E7
  ora #$19
  sta temp_ptr_hi
  lda #$05
  jsr _func_866e
  rts
_label_8d85:
  lda joypad1_press
  and #$10
  beq _label_8d8e
  jmp Reset
_label_8d8e:
  rts

_func_8d8f:
  lda a:_data_8d96_indexed,X
  sta a:_data_8d96_indexed,X
  rts

_data_8d96_indexed:
.byte $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf

_func_8d9e:
  asl a
  tax
  pha
  lda a:_data_be32,X
  sta temp_var_11
  lda a:_data_be32+1,X
  sta temp_var_12
  jsr load_graphics_data
  pla
  tax
  lda a:_data_be52,X
  sta temp_var_11
  lda a:_data_be52+1,X
  sta temp_var_12
  jsr load_palette
  rts

_func_8dbe:
  ldx #$00
_label_8dc0:
  lda a:_data_8f90_indexed,X
  cmp #$FF
  beq _label_8dce
  sta a:temp_var_208,X
  inx
  jmp _label_8dc0
_label_8dce:
  rts

_func_8dcf:
  lda joypad1_press
  and #$84
  beq _label_8de1
  inc temp_var_6b
  lda temp_var_6b
  cmp #$03
  bcc _label_8de1
  lda #$00
  sta temp_var_6b
_label_8de1:
  lda joypad1_press
  and #$48
  beq _label_8def
  dec temp_var_6b
  bpl _label_8def
  lda #$02
  sta temp_var_6b
_label_8def:
  ldx temp_var_6b
  lda joypad1_press
  and #$01
  beq _label_8e00
  lda game_var_68,X
  cmp a:_data_8e0d_indexed,X
  bcs _label_8e00
  inc game_var_68,X
_label_8e00:
  lda joypad1_press
  and #$02
  beq _label_8e0c
  lda game_var_68,X
  beq _label_8e0c
  dec game_var_68,X
_label_8e0c:
  rts

_data_8e0d_indexed:
.byte $01, $01, $01

_func_8e10:
  ldy #$00
  lda game_var_68
  asl a
  tax
  lda a:_data_8ef3_indexed,X
  sta temp_var_11
  lda a:_data_8ef4_indexed,X
  sta temp_var_12
  lda a:_data_8f28_indexed,X
  sta a:temp_var_4e2,Y
  iny
  lda a:_data_8f29_indexed,X
  sta a:temp_var_4e2,Y
  iny
  lda temp_var_69
  asl a
  tax
  lda a:_data_8ef7,X
  sta temp_var_13
  lda a:_data_8ef7+1,X
  sta temp_var_14
  lda a:_data_8f2c,X
  sta a:temp_var_4e2,Y
  iny
  lda a:_data_8f2c+1,X
  sta a:temp_var_4e2,Y
  iny
  lda temp_var_6a
  asl a
  tax
  lda a:_data_8efb,X
  sta temp_var_15
  lda a:_data_8efb+1,X
  sta z:$16
  lda a:_data_8f30,X
  sta a:temp_var_4e2,Y
  iny
  lda a:_data_8f30+1,X
  sta a:temp_var_4e2,Y
  iny
  rts

_func_8e67:
  lda #$00
  sta temp_var_21
  lda #$14
  sta temp_var_1b
_label_8e6f:
  ldx temp_var_21
  lda a:_data_8eef_indexed,X
  sta temp_var_20
  sta temp_var_23
  txa
  asl a
  tax
  lda temp_var_11,X
  sta temp_var_05
  lda temp_var_12,X
  sta temp_var_06
  lda a:temp_var_4e2,X
  sta temp_var_07
  lda a:temp_var_4e3,X
  sta temp_var_08
  lda temp_var_1b
  pha
  ldy #$00
_label_8e92:
  ldx temp_var_1b
  lda (temp_var_05),Y
  sta a:sprite_tile_0,X
  inc temp_var_1b
  inc temp_var_1b
  inc temp_var_1b
  inc temp_var_1b
  iny
  dec temp_var_20
  bne _label_8e92
  pla
  sta temp_var_1b
  ldy #$00
_label_8eab:
  ldx temp_var_1b
  lda (temp_var_07),Y
  sta a:sprite_ram,X
  iny
  lda (temp_var_07),Y
  sta a:sprite_x_0,X
  lda temp_var_6b
  cmp temp_var_21
  bne _label_8ec8
  lda temp_var_6c
  and #$04
  bne _label_8ec8
  lda #$00
  beq _label_8eca
_label_8ec8:
  lda #$03
_label_8eca:
  sta a:sprite_attr_0,X
  inc temp_var_1b
  inc temp_var_1b
  inc temp_var_1b
  inc temp_var_1b
  iny
  dec temp_var_23
  bne _label_8eab
  inc temp_var_21
  ldx temp_var_21
  cpx #$03
  bcc _label_8e6f
  rts

_func_8ee3:
  ldx #$00
  txa
_label_8ee6:
  sta a:temp_var_358,X
  inx
  cpx #$10
  bne _label_8ee6
  rts

_data_8eef_indexed:
.byte $08, $05, $05, $05

_data_8ef3_indexed:
.byte $ff

_data_8ef4_indexed:
.byte $8e, $07, $8f

_data_8ef7:
.byte $0f, $8f, $14, $8f

_data_8efb:
.byte $19, $8f, $1e, $8f, $31, $50, $4c, $41, $59, $45, $52, $ff, $32, $50, $4c, $41
.byte $59, $45, $52, $53, $54, $59, $50, $45, $41, $54, $59, $50, $45, $42, $42, $47
.byte $4d, $40, $31, $42, $47, $4d, $40, $32, $53, $54, $41, $52, $54

_data_8f28_indexed:
.byte $34

_data_8f29_indexed:
.byte $8f, $44, $8f

_data_8f2c:
.byte $54, $8f, $5e, $8f

_data_8f30:
.byte $68
.byte $8f, $72, $8f, $48, $30, $48, $40, $48, $48, $48, $50, $48, $58, $48, $60, $48
.byte $68, $48, $70, $48, $88, $48, $98, $48, $a0, $48, $a8, $48, $b0, $48, $b8, $48
.byte $c0, $48, $c8, $78, $30, $78, $38, $78, $40, $78, $48, $78, $58, $78, $88, $78
.byte $90, $78, $98, $78, $a0, $78, $b0, $a8, $30, $a8, $38, $a8, $40, $a8, $48, $a8
.byte $50, $a8, $88, $a8, $90, $a8, $98, $a8, $a0, $a8, $a8

_data_8f7c_indexed:
.byte $c8, $53, $03, $6c, $c8, $54, $03, $74, $c8, $41, $03, $7c, $c8, $52, $03, $84
.byte $c8, $54, $03, $8c

_data_8f90_indexed:
.byte $46, $8d, $23, $40, $4e, $be, $23, $40, $56, $b3, $23, $40, $5e, $b4, $23, $40
.byte $66, $b5, $23, $40, $6e, $90, $03, $40, $76, $91, $03, $40, $7e, $94, $03, $40
.byte $36, $8c, $23, $48, $3e, $95, $23, $48, $46, $96, $23, $48, $4e, $92, $23, $48
.byte $56, $93, $23, $48, $5e, $97, $23, $48, $66, $99, $23, $48, $6e, $9a, $03, $48
.byte $76, $9c, $03, $48, $7e, $9d, $03, $48, $86, $98, $03, $48, $2e, $8b, $23, $50
.byte $36, $9b, $23, $50, $3e, $9e, $23, $50, $46, $9f, $23, $50, $76, $a0, $03, $50
.byte $7e, $a1, $03, $50, $86, $a2, $03, $50, $8e, $a3, $03, $50, $f8, $8e, $03, $58
.byte $2e, $a4, $23, $58, $7e, $a5, $03, $58, $86, $a6, $03, $58, $8e, $a8, $03, $58
.byte $96, $a9, $03, $58, $8e, $aa, $03, $60, $97, $ab, $03, $60, $9e, $ac, $03, $60
.byte $96, $ae, $03, $68, $9e, $ad, $03, $68, $9e, $af, $03, $70, $4e, $b0, $23, $aa
.byte $56, $b1, $23, $aa, $5e, $a7, $23, $aa, $66, $b2, $23, $aa, $6e, $b6, $03, $aa
.byte $76, $b7, $03, $aa, $7e, $b8, $03, $aa, $56, $bd, $23, $b2, $5e, $b9, $23, $b2
.byte $66, $ba, $23, $b2, $6e, $bb, $03, $b2, $76, $bc, $03, $b2, $ff

_data_905d_indexed:
.byte $54, $4f, $4d, $31, $30, $30, $30, $ff, $32, $30, $30, $30, $30, $4a, $4f, $45
.byte $ff, $35, $30, $30, $ff, $31, $30, $30, $30, $30, $54, $52, $49, $ff, $34, $35
.byte $30, $ff, $ff, $39, $30, $30, $30, $48, $40, $59, $ff, $34, $30, $30, $ff, $ff
.byte $38, $30, $30, $30, $4a, $55, $4e, $ff, $33, $35, $30, $ff, $ff, $37, $30, $30
.byte $30, $4a, $41, $43, $ff, $33, $30, $30, $ff, $ff, $36, $30, $30, $30, $44, $40
.byte $48, $ff, $32, $35, $30, $ff, $ff, $35, $30, $30, $30, $4a, $49, $4e, $ff, $32
.byte $30, $30, $ff, $ff, $34, $30, $30, $30, $42, $4f, $42, $ff, $31, $35, $30, $ff
.byte $ff, $33, $30, $30, $30, $4b, $41, $54, $ff, $31, $30, $30, $ff, $ff, $32, $30
.byte $30, $30, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e
.byte $4f, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $40, $ff, $ff, $ff
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ef, $f1, $f2, $f2
.byte $f1, $ff, $d9, $e7, $e2, $dc, $e0, $e8, $e7, $e2, $ff, $ec, $db, $e3, $de

_func_911c:
  lda #$00
  sta PPU_CTRL
  sta PPU_MASK
  lda #$1C
  sta temp_var_19
  lda #$24
  sta temp_var_15
  ldx #$00
  lda a:_data_917f_indexed,X
  sta a:_data_917f_indexed,X
  lda #$06
  sta temp_var_18
  lda #$00
  sta temp_var_17
  sta temp_var_21
_label_913e:
  ldy #$00
  lda PPU_STATUS
  lda temp_var_19
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR
  lda PPU_DATA
_label_9150:
  lda PPU_DATA
  sta (temp_var_17),Y
  iny
  bne _label_9150
  lda PPU_STATUS
  lda temp_var_15
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR
  ldy #$00
_label_9167:
  lda (temp_var_17),Y
  sta PPU_DATA
  iny
  bne _label_9167
  inc temp_var_21
  lda temp_var_21
  cmp #$04
  bcs _label_917e
  inc temp_var_19
  inc temp_var_15
  jmp _label_913e
_label_917e:
  rts

_data_917f_indexed:
.byte $00

_label_9180:
  lda temp_var_66
  jsr jump_table_engine

  .word _label_9191
  .word _label_91bf
  .word _label_91ce
  .word _label_91dd
  .word _label_9215
  .word _label_922a

_label_9191:
  inc temp_var_8e
  lda temp_var_8e
  cmp #$80
  bcc _label_91be
  jsr stop_all_music
  lda #$01
  sta a:temp_var_d2
  lda #$07
  sta a:audio_track
  jsr _func_de4b
  lda #$00
  sta a:temp_var_d2
  sta temp_var_8e
  jsr _func_a84b
  jsr _func_99be
  jsr clear_sprites
  jsr _func_8ee3
  inc temp_var_66
_label_91be:
  rts
_label_91bf:
  lda game_state_8c
  beq _label_91c6
  inc temp_var_66
  rts
_label_91c6:
  lda #$00
  sta game_state_var
  jsr _func_a854
  rts
_label_91ce:
  lda game_state_8d
  beq _label_91d5
  inc temp_var_66
  rts
_label_91d5:
  lda #$01
  sta game_state_var
  jsr _func_99c7
  rts
_label_91dd:
  ldx #$00
  ldy #$00
  lda temp_var_8f
  beq _label_91e7
  ldx #$08
_label_91e7:
  lda a:_data_9205_indexed,X
  sta a:ppu_update_flag,Y
  inx
  iny
  cpy #$08
  bcc _label_91e7
  lda #$00
  sta a:ppu_update_flag,Y
  lda game_var_68
  bne _label_9202
  inc a:ppu_update_flag
  inc a:ppu_update_flag
_label_9202:
  inc temp_var_66
  rts

_data_9205_indexed:
.byte $87, $21, $63, $fc, $d9, $23, $73, $fc, $97, $21, $63, $fc, $dd, $23, $73, $fc

_label_9215:
  inc temp_var_8e
  lda temp_var_8e
  cmp #$F0
  bcc _label_9229
  lda #$00
  sta temp_var_8e
  inc temp_var_66
  jsr _func_a85e
  jsr _func_99d1
_label_9229:
  rts
_label_922a:
  lda temp_var_69
  beq _label_9236
  lda temp_var_57
  cmp #$04
  bne _label_9236
  inc temp_var_57
_label_9236:
  inc temp_var_57
  ldx temp_var_57
  cpx #$06
  bcc _label_924e
  inc temp_var_56
  lda temp_var_56
  cmp #$04
  bcc _label_924a
  lda #$00
  sta temp_var_56
_label_924a:
  ldx #$00
  stx temp_var_57
_label_924e:
  lda a:_data_fccd_indexed,X
  sta temp_var_32
  lda temp_var_57
  ror a
  bcc _label_9261
  lda #$04
  sta screen_mode
  lda #$00
  sta temp_var_66
  rts
_label_9261:
  sta temp_var_20
  lda temp_var_56
  asl a
  clc
  adc temp_var_56
  adc temp_var_20
  and #$0F
  sta temp_var_88
  dec temp_var_88
  bpl _label_9277
  lda #$0B
  sta temp_var_88
_label_9277:
  lda #$00
  sta temp_var_66
  lda #$08
  sta screen_mode
  jsr _func_a85e
  jsr _func_99d1
  rts
_label_9286:
  inc temp_var_66
  cmp #$80
  bcc _label_9292
  lda #$00
  sta temp_var_66
  sta screen_mode
_label_9292:
  rts
_label_9293:
  lda temp_var_66
  bne _label_92e1
  ldx #$00
_label_9299:
  lda a:_data_fc9f_indexed,X
  sta a:ppu_update_flag,X
  inx
  cpx #$08
  bcc _label_9299
  lda #$00
  sta a:ppu_update_flag,X
  lda game_var_68
  beq _label_92b3
  dec a:ppu_update_flag
  dec a:ppu_update_flag
_label_92b3:
  ldx #$00
_label_92b5:
  lda a:_data_92d9_indexed,X
  sta a:sprite_y_1,X
  inx
  cpx #$08
  bne _label_92b5
  lda game_var_91
  clc
  adc #$30
  sta a:sprite_tile_1
  lda game_var_68
  beq _label_92d6
  lda #$5C
  sta a:$0207
  lda #$18
  sta a:$020B
_label_92d6:
  inc temp_var_66
  rts

_data_92d9_indexed:
.byte $90, $30, $21, $78, $80, $ae, $23, $34

_label_92e1:
  lda joypad1_press
  and #$08
  beq _label_92ec
  lda #$80
  sta a:temp_var_208
_label_92ec:
  lda joypad1_press
  and #$04
  beq _label_92f7
  lda #$88
  sta a:temp_var_208
_label_92f7:
  ldx #$AE
  lda frame_counter
  and #$10
  bne _label_9301
  ldx #$FF
_label_9301:
  stx a:$0209
  lda joypad1_press
  and #$80
  bne _label_930b
  rts
_label_930b:
  dec game_var_91
  dec a:sprite_tile_1
  ldx #$00
_label_9312:
  lda a:_data_fcc1_indexed,X
  sta a:ppu_update_flag,X
  inx
  cpx #$0C
  bcc _label_9312
  lda game_var_68
  beq _label_932d
  dec a:ppu_update_flag
  dec a:ppu_update_flag
  dec a:temp_var_33c
  dec a:temp_var_33c
_label_932d:
  lda a:temp_var_208
  cmp #$88
  beq _label_933e
  lda #$06
  sta screen_mode
  lda #$00
  sta temp_var_66
  beq _label_935b
_label_933e:
  lda #$00
  tax
_label_9341:
  sta a:temp_var_5ac,X
  inx
  cpx #$14
  bcc _label_9341
  sta game_state_8d
  sta game_state_8c
  lda #$03
  sta screen_mode
  lda #$00
  sta temp_var_66
  jsr _func_a85e
  jsr _func_99d1
_label_935b:
  jsr clear_sprites
  rts

_func_935f:  ; unreferenced?
  lda #$a0
  sta _data_9398
_label_9364:
  lda PPU_STATUS
  bpl _label_9364
  jsr _label_937a
  jsr _label_937a
  lda #$a0
  sta _data_9398
_label_9374:
  lda PPU_STATUS
  bpl _label_9374
  rts
_label_937a:
  lda #$00
  sta _data_9396
  jsr _label_9286
  lda #$60
  sta _data_9397
  jsr _label_938b
  rts
_label_938b:
  ldx #$04
  ldy #$3a
_label_938f:
  dey
  bne _label_938f
  dex
  bne _label_938f
  rts

_data_9396:
  .byte $00                      ; 9396

_data_9397:
  .byte $60                      ; 9397

_data_9398:
  .byte $A0                      ; 9398

process_gameplay:
  lda temp_var_b8
  beq _label_93a9
  lda temp_var_af
  bne _label_93a9
  jsr _func_a28d
  lda #$00
  sta temp_var_af
  rts
_label_93a9:
  lda temp_var_69
  bne _label_93b0
  jsr _func_a23c
_label_93b0:
  lda temp_var_b4
  bmi _label_93be
  lda temp_var_69
  bne _label_93be
  lda frame_counter
  bne _label_93be
  inc temp_var_b6
_label_93be:
  lda temp_var_af
  jsr jump_table_engine

  .word _label_93d5
  .word _label_93fe
  .word _label_9463
  .word _label_989e
  .word _label_9a54
  .word _label_94a3
  .word _label_95fb
  .word _label_966f
  .word _label_9921

_label_93d5:
  lda #$A4
  sta temp_var_9c
  lda #$CE
  sta temp_var_9d
  lda #$2B
  sta temp_var_a0
  inc temp_var_af
  lda #$00
  sta temp_var_a9
  sta temp_var_9b
  sta temp_var_35
  sta temp_var_34
  lda #$08
  sta temp_var_93
  jsr _func_94e4
  lda temp_var_b5
  cmp #$05
  bne _label_93fd
  jsr _func_9a25
_label_93fd:
  rts
_label_93fe:
  jsr _func_967c
  lda temp_var_2b
  and #$C0
  beq _label_941f
  lda #$01
  sta a:temp_var_d8
  lda #$03
  sta a:temp_var_d7
  lda temp_var_2b
  and #$80
  beq _label_941c
  lda #$02
  sta a:temp_var_d7
_label_941c:
  jsr _func_e216
_label_941f:
  lda a:temp_var_6ce
  beq _label_9427
  jsr _func_9581
_label_9427:
  ldx temp_var_b3
  beq _label_9450
  lda a:temp_var_359
  cmp #$07
  bcc _label_9451
  lda a:temp_var_38d,X
  sta a:temp_var_389
  lda a:temp_var_39d,X
  sta a:temp_var_399
  lda #$04
  clc
  adc a:temp_var_389
  sta a:temp_var_389
  lda #$04
  clc
  adc a:temp_var_399
  sta a:temp_var_399
_label_9450:
  rts
_label_9451:
  lda frame_counter
  ror a
  and #$03
  sta temp_var_20
  lda a:temp_var_3af
  and #$FC
  ora temp_var_20
  sta a:temp_var_3af
  rts
_label_9463:
  lda frame_counter
  ror a
  bcc _label_9469
  rts
_label_9469:
  jsr _func_986b
  jsr _func_955f
  lda temp_var_b3
  beq _label_948f
  lda a:temp_var_359
  cmp #$07
  bcc _label_948f
  ldx temp_var_b3
  lda temp_var_a0,X
  sta temp_var_b4
  tax
  lda a:temp_var_5db,X
  ora #$40
  sta a:temp_var_5db,X
  lda #$00
  sta temp_var_b3
  sta temp_var_b6
_label_948f:
  inc temp_var_af
  lda #$01
  sta a:temp_var_d8
  lda #$00
  sta a:temp_var_d7
  jsr _func_e216
  lda #$00
  sta temp_var_b0
  rts
_label_94a3:
  jsr _func_9b8c
  rts

_func_94a7:
  ldx temp_var_b9
  lda #$04
  sta temp_var_1f
  lda temp_var_9b
  asl a
  asl a
  tay
_label_94b2:
  lda (temp_var_99),Y
  sta temp_var_1b
  and #$F0
  sta temp_var_1c
  clc
  adc temp_var_9c
  sta a:temp_var_388,X
  lda temp_var_1b
  and #$0F
  asl a
  asl a
  asl a
  asl a
  clc
  adc temp_var_9d
  sta a:temp_var_398,X
  lda #$10
  and temp_var_1c
  beq _label_94dd
  lda a:temp_var_398,X
  clc
  adc #$08
  sta a:temp_var_398,X
_label_94dd:
  inx
  iny
  dec temp_var_1f
  bne _label_94b2
  rts

_func_94e4:
  jsr _func_85a4
  lda temp_var_39
  and #$07
  sta temp_var_1d
  jsr _func_85a4
  lda temp_var_39
  and #$7F
  tay
  lda (temp_var_37),Y
  sta temp_var_1b
  ror a
  ror a
  ror a
  and #$0E
  sta z:$94
  tax
  lda a:_data_f2e0,X
  sta temp_var_99
  lda a:_data_f2e0+1,X
  sta z:$9A
  lda a:_data_f35b,X
  sta temp_var_19
  lda a:_data_f35b+1,X
  sta temp_var_1a
  lda temp_var_1b
  and #$0F
  asl a
  asl a
  tay
  ldx #$00
_label_951e:
  stx temp_var_21
  lda (temp_var_19),Y
  clc
  adc temp_var_1d
  tax
  lda a:_data_f34e_indexed,X
  ldx temp_var_21
  sta temp_var_a5,X
  iny
  inx
  cpx #$04
  bcc _label_951e
  ldx #$00
  lda #$06
  sta temp_var_12
_label_9539:
  stx temp_var_21
  lda temp_var_a5,X
  sta temp_var_11
  jsr update_display_elements
  inc temp_var_12
  ldx temp_var_21
  inx
  cpx #$04
  bcc _label_9539
  lda #$06
  sta temp_var_b9
  ldy #$00
_label_9551:
  lda (temp_var_99),Y
  clc
  adc temp_var_a0
  sta a:temp_var_a1,Y
  iny
  cpy #$04
  bcc _label_9551
  rts

_func_955f:
  lda #$00
  sta temp_var_11
  lda #$06
  sta temp_var_12
  jsr update_display_elements
  inc temp_var_12
  lda a:temp_var_35f
  cmp #$05
  bne _label_9575
  inc temp_var_12
_label_9575:
  jsr update_display_elements
  inc temp_var_12
  lda temp_var_12
  cmp #$0A
  bcc _label_9575
  rts

_func_9581:
  lda frame_counter
  ror a
  bcc _label_9587
  rts
_label_9587:
  lda a:temp_var_6ce
  tax
  and #$0F
  clc
  adc a:temp_var_5bf
  sta a:temp_var_5bf
  txa
  ror a
  ror a
  ror a
  ror a
  and #$0F
  clc
  adc a:temp_var_5be
  sta a:temp_var_5be
  ldx #$05
_label_95a4:
  lda a:temp_var_5ba,X
  cmp #$0A
  bcc _label_95b6
  inc a:temp_var_5b9,X
  clc
  adc #$06
  and #$0F
  sta a:temp_var_5ba,X
_label_95b6:
  dex
  bne _label_95a4
  lda #$06
  sta a:temp_var_6e2
  lda #$01
  sta a:temp_var_6e3
  ldx #$00
_label_95c5:
  lda a:temp_var_5ba,X
  tay
  lda a:_data_f1de_indexed,Y
  sta a:temp_var_6e4,X
  inx
  cpx #$06
  bcc _label_95c5
  ldx temp_var_35
  lda #$3A
  sta a:ppu_update_flag,X
  lda #$23
  sta a:temp_var_339,X
  lda a:_data_a17a
  sta a:temp_var_33a,X
  lda a:_data_a17b
  sta a:temp_var_33b,X
  lda #$00
  sta a:temp_var_33c,X
  sta a:temp_var_6ce
  txa
  clc
  adc #$04
  sta temp_var_35
  rts
_label_95fb:
  lda temp_var_b6
  cmp #$08
  bcc _label_9616
  ldx temp_var_b4
  lda a:temp_var_5db,X
  and #$BF
  sta a:temp_var_5db,X
  lda #$00
  sta temp_var_b6
  sta a:temp_var_359
  lda #$FF
  sta temp_var_b4
_label_9616:
  ldx #$0B
_label_9618:
  lda a:temp_var_5db,X
  beq _label_9626
  inc temp_var_af
  inc temp_var_af
  lda #$00
  sta temp_var_b0
  rts
_label_9626:
  txa
  clc
  adc #$10
  tax
  cmp #$70
  bcc _label_9618
  lda #$00
  sta temp_var_af
  lda temp_var_69
  bne _label_9663
  lda temp_var_b8
  bne _label_9662
  lda temp_var_b2
  cmp #$1E
  bcc _label_9650
  lda #$00
  sta temp_var_b2
  inc temp_var_b5
  lda temp_var_b5
  cmp #$05
  beq _label_9650
  jsr _func_99e0
_label_9650:
  lda temp_var_b1
  cmp #$C8
  bcc _label_9662
_label_9656:
  lda #$07
  sta temp_var_af
  lda #$00
  sta temp_var_b0
  lda #$32
  sta temp_var_a9
_label_9662:
  rts
_label_9663:
  ldx temp_var_b4
  lda a:temp_var_5db,X
  and #$40
  bne _label_9662
  jmp _label_9656
_label_966f:
  lda #$01
  sta temp_var_8f
  lda #$09
  sta screen_mode
  lda #$00
  sta temp_var_66
  rts

_func_967c:
  lda temp_var_a9
  beq _label_969e
  lda temp_var_92
  and #$01
  beq _label_968b
  inc temp_var_9c
  jmp _label_9693
_label_968b:
  lda temp_var_92
  and #$02
  beq _label_9693
  dec temp_var_9c
_label_9693:
  dec temp_var_a9
  bne _label_969b
  lda #$00
  sta temp_var_92
_label_969b:
  jmp _label_978c
_label_969e:
  lda joypad2_state
  and #$08
  bne _label_96aa
  lda #$00
  sta temp_var_bb
  beq _label_96c0
_label_96aa:
  inc temp_var_bb
  lda temp_var_bb
  cmp #$08
  bcc _label_96bc
  lda #$00
  sta temp_var_bb
  inc a:temp_var_6ce
  inc a:temp_var_6ce
_label_96bc:
  lda #$00
  sta temp_var_bc
_label_96c0:
  lda temp_var_bc
  bne _label_96ce
  lda temp_var_33
  sta temp_var_bc
  dec temp_var_93
  dec temp_var_9d
  dec temp_var_9d
_label_96ce:
  dec temp_var_bc
  lda temp_var_93
  bne _label_96ea
  lda #$08
  sta temp_var_93
  lda temp_var_a0
  sta temp_var_20
  dec temp_var_20
  lda temp_var_9b
  sta temp_var_23
  jsr _func_97d6
  beq _label_96ea
  inc temp_var_af
  rts
_label_96ea:
  lda joypad2_state
  and #$03
  bne _label_96f3
  jmp _label_978c
_label_96f3:
  cmp #$03
  bne _label_96fe
  lda #$00
  sta temp_var_92
  jmp _label_978c
_label_96fe:
  sta temp_var_92
  lda joypad2_state
  and #$01
  beq _label_970f
  lda temp_var_a0
  clc
  adc #$10
  and #$F0
  sta temp_var_20
_label_970f:
  lda joypad2_state
  and #$02
  beq _label_971e
  lda temp_var_a0
  sec
  sbc #$10
  and #$F0
  sta temp_var_20
_label_971e:
  lda temp_var_a0
  and #$0F
  ora temp_var_20
  sta temp_var_20
  lda temp_var_93
  cmp #$05
  bcc _label_9747
  lda temp_var_a0
  sta temp_var_1c
  and #$0F
  cmp #$0E
  bcc _label_973c
  lda temp_var_a0
  eor #$10
  sta temp_var_1c
_label_973c:
  lda temp_var_1c
  and #$10
  beq _label_975f
  inc temp_var_20
  jmp _label_975f
_label_9747:
  lda temp_var_a0
  sta temp_var_1c
  and #$0F
  cmp #$0E
  bcc _label_9757
  lda temp_var_a0
  eor #$10
  sta temp_var_1c
_label_9757:
  lda temp_var_1c
  and #$10
  bne _label_975f
  dec temp_var_20
_label_975f:
  lda temp_var_9b
  sta temp_var_23
  jsr _func_97d6
  beq _label_9771
  lda #$00
  sta temp_var_92
  sta temp_var_a9
  jmp _label_978c
_label_9771:
  lda #$00
  sta temp_var_bc
  lda #$10
  sta temp_var_a9
  lda temp_var_93
  cmp #$05
  bcc _label_9787
  sec
  sbc #$04
  sta temp_var_93
  jmp _label_978c
_label_9787:
  clc
  adc #$04
  sta temp_var_93
_label_978c:
  lda temp_var_9b
  sta temp_var_23
  and #$01
  beq _label_97b5
  lda temp_var_2b
  and #$80
  beq _label_979c
  dec temp_var_23
_label_979c:
  lda temp_var_2b
  and #$40
  beq _label_97a4
  inc temp_var_23
_label_97a4:
  lda temp_var_23
  and #$03
  sta temp_var_23
  lda temp_var_a0
  sta temp_var_20
  jsr _func_97d6
  jsr _func_94a7
  rts
_label_97b5:
  lda temp_var_2b
  and #$80
  beq _label_97bd
  inc temp_var_23
_label_97bd:
  lda temp_var_2b
  and #$40
  beq _label_97c5
  dec temp_var_23
_label_97c5:
  lda temp_var_23
  and #$03
  sta temp_var_23
  lda temp_var_a0
  sta temp_var_20
  jsr _func_97d6
  jsr _func_94a7
  rts

_func_97d6:
  lda temp_var_20
  and #$F0
  sta temp_var_21
  lda temp_var_20
  and #$0F
  sta temp_var_22
  lda #$04
  sta temp_var_1f
  ldx #$00
  lda temp_var_23
  asl a
  asl a
  sta temp_var_25
_label_97ee:
  ldy temp_var_25
  lda (temp_var_99),Y
  sta temp_var_1e
  lda temp_var_21
  sta temp_var_1c
  lda temp_var_22
  cmp #$0E
  bcc _label_9805
  lda temp_var_21
  clc
  adc #$10
  sta temp_var_1c
_label_9805:
  lda temp_var_1c
  and #$10
  beq _label_9813
  lda temp_var_1e
  and #$10
  beq _label_9813
  inc temp_var_1e
_label_9813:
  lda temp_var_1e
  and #$F0
  clc
  adc temp_var_21
  sta temp_var_1d
  cmp #$70
  bne _label_9823
  lda #$FF
  rts
_label_9823:
  lda temp_var_1e
  and #$0F
  clc
  adc temp_var_22
  sta temp_var_1c
  and #$0F
  cmp #$0E
  bcc _label_9835
_label_9832:
  lda #$FF
  rts
_label_9835:
  lda temp_var_1c
  clc
  adc temp_var_1d
  cmp #$70
  bcs _label_9832
  tay
  lda a:temp_var_5db,Y
  and #$7F
  beq _label_9847
  rts
_label_9847:
  tya
  sta temp_var_bd,X
  inx
  inc temp_var_25
  dec temp_var_1f
  bne _label_97ee
  lda #$04
  sta temp_var_1f
  ldx #$00
_label_9857:
  lda temp_var_bd,X
  sta temp_var_a1,X
  inx
  dec temp_var_1f
  bne _label_9857
  lda temp_var_20
  sta temp_var_a0
  lda temp_var_23
  sta temp_var_9b
  lda #$00
  rts

_func_986b:
  ldx #$00
  stx temp_var_21
_label_986f:
  ldy temp_var_a1,X
  lda temp_var_a5,X
  sta temp_var_1b
  sta a:temp_var_5db,Y
  inc temp_var_21
  asl a
  tax
  lda a:_data_f26b,X
  sta temp_var_17
  lda a:_data_f26b+1,X
  sta temp_var_18
  tya
  jsr _func_8511
  jsr _func_85dc
  jsr _func_8535
  ldx temp_var_21
  cpx #$04
  bcc _label_986f
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  rts
_label_989e:
  lda temp_var_b0
  cmp #$00
  bne _label_98da
  ldx #$00
  stx temp_var_ab
_label_98a8:
  stx temp_var_21
  lda temp_var_a1,X
  sta temp_var_20
  dec temp_var_20
_label_98b0:
  lda temp_var_20
  and #$0F
  cmp #$0E
  bcs _label_98d0
  ldy temp_var_20
  lda a:temp_var_5db,Y
  bne _label_98d0
  lda #$80
  sta a:temp_var_5db,Y
  tya
  ldx temp_var_ab
  sta a:temp_var_692,X
  inc temp_var_ab
  dec temp_var_20
  bpl _label_98b0
_label_98d0:
  ldx temp_var_21
  inx
  cpx #$04
  bcc _label_98a8
  inc temp_var_b0
  rts
_label_98da:
  lda frame_counter
  ror a
  bcc _label_98e0
  rts
_label_98e0:
  lda #$DA
  sta temp_var_17
  lda #$F2
  sta temp_var_18
  lda #$0C
  sta temp_var_1f
  ldy #$00
_label_98ee:
  dec temp_var_ab
  bpl _label_990a
  inc temp_var_af
  lda temp_var_b3
  bne _label_98fa
  inc temp_var_af
_label_98fa:
  lda #$00
  ldy temp_var_34
  sta temp_var_b0
  sta a:sprite_flag,Y
  sta temp_var_92
  lda #$03
  sta temp_var_a9
  rts
_label_990a:
  ldx temp_var_ab
  lda a:temp_var_692,X
  jsr _func_8511
  jsr _func_85dc
  dec temp_var_1f
  bpl _label_98ee
  ldy temp_var_34
  lda #$00
  sta a:sprite_flag,Y
  rts
_label_9921:
  lda temp_var_b0
  jsr jump_table_engine

  .word _label_992e
  .word _label_9939
  .word _label_9953
  .word _label_998c

_label_992e:
  lda #$0A
  sta screen_mode
  lda #$00
  sta temp_var_66
  inc temp_var_b0
  rts
_label_9939:
  lda #$00
  sta a:temp_var_359
  sta a:$035E
  sta a:temp_var_35f
  sta a:$0360
  sta a:$0361
  lda #$0A
  sta temp_var_ab
  inc temp_var_b0
  jmp _label_e275
_label_9953:
  lda frame_counter
  ror a
  bcc _func_9959
  rts

_func_9959:
  lda #$75
  sta temp_var_17
  lda #$F2
  sta temp_var_18
  lda temp_var_ab
_label_9963:
  sta temp_var_a9
  jsr _func_8511
  jsr _func_85dc
  lda temp_var_a9
  clc
  adc #$10
  cmp #$70
  bcc _label_9963
  lda #$00
  sta a:sprite_flag,X
  dec temp_var_ab
  bpl _label_998b
  inc temp_var_b0
  ldy #$00
  lda #$00
_label_9983:
  sta a:temp_var_5db,Y
  iny
  cpy #$70
  bcc _label_9983
_label_998b:
  rts
_label_998c:
  lda frame_counter
  ror a
  bcc _label_9992
  rts
_label_9992:
  ldx temp_var_35
  ldy #$00
_label_9996:
  lda a:_data_99b6_indexed,Y
  sta a:ppu_update_flag,X
  inx
  iny
  cpy #$08
  bcc _label_9996
  lda #$00
  sta a:ppu_update_flag,X
  stx temp_var_35
  lda #$01
  sta game_state_8d
  lda #$00
  sta temp_var_ae
  sta temp_var_ad
  jmp _func_99d1

_data_99b6_indexed:
.byte $b7, $21, $69, $fc, $dd, $23, $73, $fc

_func_99be:
  lda #$00
  sta temp_var_b0
  lda #$0A
  sta temp_var_ab
  rts

_func_99c7:
  jsr _func_9959
  lda temp_var_b0
  beq _label_99d0
  inc temp_var_66
_label_99d0:
  rts

_func_99d1:
  lda #$00
  tax
_label_99d4:
  sta temp_var_af,X
  inx
  cpx #$0A
  bcc _label_99d4
  lda #$FF
  sta temp_var_b4
  rts

_func_99e0:
  lda temp_var_ad
  bne _label_99fc
  jsr _func_85a4
  lda temp_var_39
  and #$03
  tay
  ldx #$00
_label_99ee:
  lda a:_data_a8b2_indexed,Y
  sta a:temp_var_6ea,X
  iny
  inx
  cpx #$05
  bcc _label_99ee
  stx temp_var_ad
_label_99fc:
  ldx temp_var_ad
  lda a:temp_var_6e9,X
  clc
  adc #$07
  sta temp_var_11
  lda #$01
  sta temp_var_12
  jsr update_display_elements
  jsr _func_85a4
  lda temp_var_39
  and #$03
  sta temp_var_b3
  inc temp_var_b3
  ldx temp_var_b4
  bmi _label_9a24
  lda a:temp_var_5db,X
  and #$BF
  sta a:temp_var_5db,X
_label_9a24:
  rts

_func_9a25:
  lda #$02
  sta temp_var_b3
  lda #$05
  sta temp_var_11
  lda #$07
  sta temp_var_12
  jsr update_display_elements
  lda #$00
  sta temp_var_b2
  ldx temp_var_b4
  bmi _label_9a53
  lda a:temp_var_5db,X
  and #$BF
  sta a:temp_var_5db,X
  lda #$FF
  sta temp_var_b4
  lda #$00
  sta temp_var_11
  lda #$01
  sta temp_var_12
  jsr update_display_elements
_label_9a53:
  rts
_label_9a54:
  lda frame_counter
  ror a
  bcc _label_9a5a
  rts
_label_9a5a:
  lda temp_var_b0
  bne _label_9a6d
  inc temp_var_b0
  lda #$01
  sta a:temp_var_d8
  lda #$05
  sta a:temp_var_d7
  jmp _func_e216
_label_9a6d:
  cmp #$01
  bne _label_9abb
  lda #$05
  sta temp_var_11
  lda #$08
  sta temp_var_12
  jsr update_display_elements
  lda temp_var_92
  asl a
  tax
  lda a:_data_fce0_indexed,X
  clc
  adc a:temp_var_38f
  sta a:$0390
  lda a:_data_fce0_indexed+1,X
  clc
  adc a:temp_var_39f
  sta a:$03A0
  lda frame_counter
  ror a
  and #$03
  sta temp_var_20
  lda a:temp_var_3af
  and #$FC
  ora temp_var_20
  sta a:temp_var_3af
  sta a:$03B0
  inc temp_var_92
  lda temp_var_92
  cmp #$18
  bne _label_9aba
  lda #$00
  sta temp_var_92
  dec temp_var_a9
  bne _label_9aba
  inc temp_var_b0
_label_9aba:
  rts
_label_9abb:
  cmp #$02
  bne _label_9b2e
  lda temp_var_a2
  sta a:temp_var_64c
  tax
  jsr _func_85a4
  lda temp_var_39
  and #$03
  sta temp_var_b3
  inc temp_var_b3
  lda temp_var_b3
  sta a:temp_var_5db,X
  ldy #$01
  sty temp_var_25
  lda a:temp_var_64c
  and #$10
  beq _label_9ae6
  tya
  clc
  adc #$06
  sta temp_var_25
_label_9ae6:
  lda #$01
  sta temp_var_21
  lda #$06
  sta temp_var_1f
_label_9aee:
  ldy temp_var_25
  lda a:_data_fcd3_indexed,Y
  inc temp_var_25
  clc
  adc a:temp_var_64c
  tax
  and #$0F
  cmp #$0D
  bcs _label_9b20
  txa
  and #$F0
  cmp #$70
  bcs _label_9b20
  lda a:temp_var_5db,X
  and #$07
  bne _label_9b13
  sta a:temp_var_5db,X
  beq _label_9b18
_label_9b13:
  lda temp_var_b3
  sta a:temp_var_5db,X
_label_9b18:
  txa
  ldx temp_var_21
  sta a:temp_var_64c,X
  inc temp_var_21
_label_9b20:
  dec temp_var_1f
  bne _label_9aee
  ldx temp_var_21
  lda #$FF
  sta a:temp_var_64c,X
  inc temp_var_b0
  rts
_label_9b2e:
  cmp #$03
  bne _label_9b79
  ldy #$00
  sty temp_var_22
_label_9b36:
  ldy temp_var_22
  lda a:temp_var_64c,Y
  bmi _label_9b5f
  sta temp_var_21
  jsr _func_8511
  ldx temp_var_21
  lda a:temp_var_5db,X
  sta temp_var_1b
  asl a
  tax
  lda a:_data_f26b,X
  sta temp_var_17
  lda a:_data_f26b+1,X
  sta temp_var_18
  jsr _func_85dc
  jsr _func_8535
  inc temp_var_22
  bpl _label_9b36
_label_9b5f:
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  lda #$00
  sta temp_var_11
  lda #$07
  sta temp_var_12
  jsr update_display_elements
  inc temp_var_12
  jsr update_display_elements
  inc temp_var_b0
  rts
_label_9b79:
  inc temp_var_b0
  lda temp_var_b0
  cmp #$0F
  bcc _label_9b8b
  lda #$00
  sta temp_var_b0
  sta temp_var_b5
  sta temp_var_b3
  inc temp_var_af
_label_9b8b:
  rts

_func_9b8c:
  lda temp_var_b0
  jsr jump_table_engine

  .word _label_9ba5
  .word _label_a062
  .word _label_9cab
  .word _label_9e91
  .word _label_9bd5
  .word _label_a17c
  .word _label_9c65
  .word _label_9f52
  .word _label_9fbc
  .word _label_9bff

_label_9ba5:
  lda #$00
  sta temp_var_ab
  lda #$04
  sta temp_var_1e
_label_9bad:
  lda temp_var_1e
  sta temp_var_20
  jsr _func_9da7
  dec temp_var_1e
  bne _label_9bad
  lda a:temp_var_6d0
  bne _label_9bca
  sta temp_var_b0
  inc temp_var_af
  lda temp_var_b7
  cmp #$03
  bcc _label_9bc9
  inc temp_var_b7
_label_9bc9:
  rts
_label_9bca:
  lda #$00
  sta temp_var_92
  sta temp_var_a9
  sta temp_var_ac
  inc temp_var_b0
  rts
_label_9bd5:
  inc temp_var_b0
  jsr _func_9c2b
  jsr _func_9c45
  ldx temp_var_b4
  bmi _label_9bf6
  lda a:temp_var_5db,X
  and #$40
  bne _label_9bf6
  lda #$00
  sta a:temp_var_359
  lda temp_var_69
  bne _label_9bf5
  lda #$FF
  sta temp_var_b4
_label_9bf5:
  rts
_label_9bf6:
  lda temp_var_ab
  bne _label_9bfc
  inc temp_var_b0
_label_9bfc:
  inc temp_var_b0
  rts
_label_9bff:
  lda frame_counter
  ror a
  bcc _label_9c05
  rts
_label_9c05:
  ldx temp_var_35
  lda #$52
  sta a:ppu_update_flag,X
  lda #$23
  sta a:temp_var_339,X
  lda #$E8
  sta a:temp_var_33a,X
  lda #$F1
  sta a:temp_var_33b,X
  lda #$00
  sta a:temp_var_33c,X
  txa
  clc
  adc #$04
  sta temp_var_35
  lda #$00
  sta temp_var_b0
  rts

_func_9c2b:
  ldx #$00
  ldy #$00
  stx temp_var_24
_label_9c31:
  ldx temp_var_24
  lda a:temp_var_692,X
  cmp #$FF
  bne _label_9c3b
  rts
_label_9c3b:
  tax
  tya
  sta a:temp_var_5db,X
  inc temp_var_24
  bne _label_9c31
  rts

_func_9c45:
  ldy #$00
  ldx #$6E
_label_9c49:
  dex
_label_9c4a:
  lda a:temp_var_5db,X
  beq _label_9c56
  bpl _label_9c5c
  txa
  sta a:temp_var_692,Y
  iny
_label_9c56:
  dex
  bpl _label_9c4a
  sty temp_var_ab
  rts
_label_9c5c:
  txa
  and #$F0
  tax
  bne _label_9c49
  sty temp_var_ab
  rts
_label_9c65:
  lda frame_counter
  ror a
  bcc _label_9c6b
  rts
_label_9c6b:
  lda #$75
  sta temp_var_17
  lda #$F2
  sta temp_var_18
  lda #$0C
  sta temp_var_1f
  ldy #$00
_label_9c79:
  dec temp_var_ab
  bpl _label_9c85
  inc temp_var_b0
  lda #$00
  sta temp_var_a9
  beq _label_9ca3
_label_9c85:
  ldx temp_var_ab
  lda a:temp_var_692,X
  sta temp_var_24
  jsr _func_8511
  lda temp_var_1a
  cmp #$24
  beq _label_9c9f
  ldx temp_var_24
  lda #$00
  sta a:temp_var_5db,X
  jsr _func_85dc
_label_9c9f:
  dec temp_var_1f
  bpl _label_9c79
_label_9ca3:
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  rts
_label_9cab:
  lda #$01
  sta a:temp_var_d8
  lda #$01
  sta a:temp_var_d7
  jsr _func_e216
  inc temp_var_b0
  rts
_label_9cbb:
  lda game_state_8d
  beq _label_9cc6
  lda #$00
  sta temp_var_66
  sta screen_mode
  rts
_label_9cc6:
  jsr _func_85a4
  and #$06
  sta temp_var_20
  lda temp_var_57
  asl a
  asl a
  asl a
  clc
  adc temp_var_20
  tax
  lda a:_data_fd16,X
  sta temp_var_a1
  lda a:_data_fd16+1,X
  sta temp_var_a2
  lda #$00
  sta temp_var_a9
  sta temp_var_ab
  inc temp_var_66
  lda #$01
  sta game_state_var
  ldx #$00
_label_9cee:
  txa
  sta a:temp_var_6ea,X
  inx
  cpx #$05
  bcc _label_9cee
  rts
_label_9cf8:
  ldx temp_var_a9
  ldy temp_var_ab
  lda (temp_var_a1),Y
  beq _label_9d33
  sta a:temp_var_5db,X
  sta temp_var_1b
  txa
  jsr _func_8511
  lda temp_var_1b
  bpl _label_9d1b
  lda #$DA
  sta temp_var_17
  lda #$F2
  sta temp_var_18
  lda #$01
  sta temp_var_1b
  bne _label_9d27
_label_9d1b:
  asl a
  tax
  lda a:_data_f26b,X
  sta temp_var_17
  lda a:_data_f26b+1,X
  sta temp_var_18
_label_9d27:
  jsr _func_85dc
  jsr _func_8535
  inc temp_var_ab
  inc temp_var_a9
  bpl _label_9cf8
_label_9d33:
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  inc temp_var_ab
  lda temp_var_a9
  and #$F0
  clc
  adc #$10
  sta temp_var_a9
  cmp #$70
  bcc _label_9d4b
  inc temp_var_66
_label_9d4b:
  rts
_label_9d4c:
  lda temp_var_57
  sta temp_var_ad
  ldx temp_var_56
  stx temp_var_ae
  lda a:_data_b8f7_indexed,X
  sta temp_var_1b
  jsr _func_a1e4
  ldx temp_var_57
  beq _label_9d78
  stx temp_var_21
_label_9d62:
  jsr _func_a207
  jsr _func_85dc
  jsr _func_8535
  dec temp_var_21
  ldx temp_var_21
  bne _label_9d62
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
_label_9d78:
  lda temp_var_57
  clc
  adc #$07
  sta temp_var_11
  lda #$01
  sta temp_var_12
  jsr update_display_elements
  lda #$B8
  sta a:temp_var_389
  lda #$1C
  sta a:temp_var_399
  ldx #$30
  lda a:temp_var_5db,X
  ora #$40
  sta a:temp_var_5db,X
  stx temp_var_b4
  lda #$00
  sta temp_var_66
  sta screen_mode
  sta temp_var_ab
  inc temp_var_ad
  rts

_func_9da7:
  ldy #$00
  ldx #$00
_label_9dab:
  lda a:temp_var_5db,X
  and #$87
  cmp temp_var_20
  beq _label_9db8
  lda #$00
  beq _label_9dbf
_label_9db8:
  iny
  txa
  sta a:temp_var_64c,Y
  lda temp_var_20
_label_9dbf:
  sta a:temp_var_471,X
  inx
  cpx #$70
  bcc _label_9dab
  cpy #$00
  bne _label_9dcc
  rts
_label_9dcc:
  ldx a:temp_var_64c,Y
  lda a:temp_var_471,X
  beq _label_9dec
  sty temp_var_25
  ldy #$00
  sty temp_var_21
  tya
  sta a:temp_var_471,X
  txa
  sta a:temp_var_66a,Y
  stx temp_var_20
  iny
  sty temp_var_ac
  jsr _func_9df0
  ldy temp_var_25
_label_9dec:
  dey
  bne _label_9dcc
  rts

_func_9df0:
  ldy #$06
  sty temp_var_22
  ldx #$00
  stx temp_var_24
_label_9df8:
  ldy temp_var_22
  lda temp_var_20
  and #$10
  beq _label_9e05
  tya
  clc
  adc #$06
  tay
_label_9e05:
  lda a:_data_fcd3_indexed,Y
  clc
  adc temp_var_20
  tax
  and #$0F
  cmp #$0E
  bcs _label_9e28
  txa
  and #$F0
  cmp #$70
  bcs _label_9e28
  lda a:temp_var_471,X
  beq _label_9e28
  stx temp_var_23
  inc temp_var_24
  ldx temp_var_24
  cpx #$02
  bcs _label_9e2e
_label_9e28:
  dec temp_var_22
  bne _label_9df8
  beq _label_9e37
_label_9e2e:
  inc temp_var_21
  ldx temp_var_21
  lda temp_var_20
  sta a:temp_var_683,X
_label_9e37:
  ldx temp_var_24
  beq _label_9e4f
  ldx temp_var_23
  lda #$00
  sta a:temp_var_471,X
  ldy temp_var_ac
  txa
  sta a:temp_var_66a,Y
  stx temp_var_20
  inc temp_var_ac
  jmp _func_9df0
_label_9e4f:
  ldx temp_var_21
  beq _label_9e5d
  lda a:temp_var_683,X
  dec temp_var_21
  sta temp_var_20
  jmp _func_9df0
_label_9e5d:
  ldy temp_var_ac
  cpy #$04
  bcc _label_9e8c
  tya
  clc
  adc a:temp_var_6cf
  sta a:temp_var_6cf
  tya
  sec
  sbc #$03
  asl a
  asl a
  clc
  adc a:temp_var_6d0
  sta a:temp_var_6d0
  dey
  ldx temp_var_ab
_label_9e7b:
  lda a:temp_var_66a,Y
  sta a:temp_var_692,X
  inx
  dey
  bpl _label_9e7b
  lda #$FF
  sta a:temp_var_692,X
  stx temp_var_ab
_label_9e8c:
  lda #$00
  sta temp_var_ac
  rts
_label_9e91:
  lda frame_counter
  ror a
  bcc _label_9e97
  rts
_label_9e97:
  inc temp_var_a9
  lda temp_var_a9
  cmp #$04
  bcc _label_9eb0
  lda #$00
  sta temp_var_a9
  sta temp_var_ac
  inc temp_var_92
  lda temp_var_92
  cmp #$08
  bcc _label_9eb0
  inc temp_var_b0
  rts
_label_9eb0:
  ldy temp_var_ac
  lda a:temp_var_692,Y
  cmp #$FF
  bne _label_9eba
  rts
_label_9eba:
  ldx #$00
_label_9ebc:
  sta a:temp_var_66a,X
  inx
  iny
  lda a:temp_var_692,Y
  cmp #$FF
  beq _label_9ecc
  cpx #$0D
  bcc _label_9ebc
_label_9ecc:
  sty temp_var_ac
  stx temp_var_24
  stx temp_var_21
  ldx #$00
  stx temp_var_34
_label_9ed6:
  ldx temp_var_34
  lda a:temp_var_66a,X
  jsr _func_8511
  lda temp_var_34
  asl a
  asl a
  tay
  lda temp_var_19
  sta a:sprite_flag,Y
  lda temp_var_1a
  sta a:temp_var_301,Y
  inc temp_var_34
  dec temp_var_24
  bne _label_9ed6
  lda #$00
  sta a:temp_var_304,Y
  ldx temp_var_92
  lda a:_data_b649_indexed,X
  cmp #$03
  bcc _label_9f05
  jsr _func_9f2b
  rts
_label_9f05:
  jsr _func_9f09
  rts

_func_9f09:
  asl a
  tax
  lda a:_data_f2c8,X
  sta temp_var_19
  lda a:_data_f2c8+1,X
  sta temp_var_1a
  ldx #$00
_label_9f17:
  txa
  asl a
  asl a
  tay
  lda temp_var_19
  sta a:temp_var_302,Y
  lda temp_var_1a
  sta a:temp_var_303,Y
  inx
  dec temp_var_21
  bpl _label_9f17
  rts

_func_9f2b:
  ldx #$00
_label_9f2d:
  lda a:temp_var_66a,X
  stx temp_var_24
  tay
  lda a:temp_var_5db,Y
  and #$07
  asl a
  tay
  txa
  asl a
  asl a
  tax
  lda a:_data_f26b,Y
  sta a:temp_var_302,X
  lda a:_data_f26b+1,Y
  sta a:temp_var_303,X
  ldx temp_var_24
  inx
  dec temp_var_21
  bpl _label_9f2d
  rts
_label_9f52:
  lda #$00
  sta temp_var_22
  lda #$FF
  sta temp_var_24
_label_9f5a:
  lda temp_var_22
  asl a
  asl a
  asl a
  asl a
  tax
  lda #$0E
  sta temp_var_1f
_label_9f65:
  lda a:temp_var_5db,X
  bne _label_9f9a
  stx temp_var_ab
  txa
  ldy temp_var_22
  sta a:temp_var_66a,Y
  inx
_label_9f73:
  lda a:temp_var_5db,X
  beq _label_9f88
  ldy temp_var_ab
  sta a:temp_var_5db,Y
  inc temp_var_ab
  lda #$00
  sta a:temp_var_5db,X
  stx temp_var_24
  inc temp_var_24
_label_9f88:
  inx
  dec temp_var_1f
  bne _label_9f73
  ldy temp_var_22
  lda temp_var_24
  sta a:temp_var_64c,Y
  lda #$FF
  sta temp_var_24
  bmi _label_9fa6
_label_9f9a:
  inx
  dec temp_var_1f
  bne _label_9f65
  ldy temp_var_22
  lda #$FF
  sta a:temp_var_64c,Y
_label_9fa6:
  inc temp_var_22
  lda temp_var_22
  cmp #$07
  bcc _label_9f5a
  lda #$00
  sta temp_var_ab
  inc temp_var_b0
  lda temp_var_b4
  bmi _label_9fbb
  jsr _func_a1bc
_label_9fbb:
  rts
_label_9fbc:
  lda frame_counter
  ror a
  bcc _label_9fc2
  rts
_label_9fc2:
  lda #$00
  sta temp_var_34
  lda #$08
  sta temp_var_1f
  ldy temp_var_ab
_label_9fcc:
  lda a:temp_var_64c,Y
  bpl _label_9fe3
_label_9fd1:
  inc temp_var_ab
  ldy temp_var_ab
  cpy #$07
  bcc _label_9fcc
  lda #$00
  ldx temp_var_34
  sta a:sprite_flag,X
  inc temp_var_b0
  rts
_label_9fe3:
  sta temp_var_24
  lda a:temp_var_66a,Y
  sta temp_var_25
  jsr _func_8511
_label_9fed:
  ldx temp_var_34
  lda temp_var_19
  sta a:sprite_flag,X
  inx
  lda temp_var_1a
  sta a:sprite_flag,X
  inx
  lda temp_var_25
  and #$0F
  cmp #$0B
  bcs _label_a036
  ldy temp_var_25
  lda a:temp_var_5db,Y
  and #$87
  sta temp_var_1b
  bmi _label_a021
  asl a
  tay
  lda a:_data_f26b,Y
  sta a:sprite_flag,X
  inx
  lda a:_data_f26b+1,Y
  sta a:sprite_flag,X
  lda #$00
  beq _label_a02c
_label_a021:
  lda #$DA
  sta a:sprite_flag,X
  inx
  lda #$F2
  sta a:sprite_flag,X
_label_a02c:
  inx
  stx temp_var_34
  lda temp_var_1b
  beq _label_a036
  jsr _func_8535
_label_a036:
  dec temp_var_1f
  beq _label_a051
  inc temp_var_25
  lda temp_var_25
  cmp temp_var_24
  bcs _label_9fd1
  lda temp_var_19
  clc
  adc #$40
  sta temp_var_19
  bcc _label_a04d
  inc temp_var_1a
_label_a04d:
  lda #$00
  beq _label_9fed
_label_a051:
  inc temp_var_25
  ldy temp_var_ab
  lda temp_var_25
  sta a:temp_var_66a,Y
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  rts
_label_a062:
  lda frame_counter
  ror a
  bcc _label_a068
  rts
_label_a068:
  lda #$00
  sta temp_var_20
  lda a:temp_var_6d0
_label_a06f:
  sec
  sbc #$0A
  bcc _label_a07e
  sta a:temp_var_6d0
  inc temp_var_20
  lda a:temp_var_6d0
  bpl _label_a06f
_label_a07e:
  lda a:temp_var_6d0
  sta a:$06D4
  lda temp_var_20
  sta a:$06D3
  ldx #$02
_label_a08b:
  lda a:temp_var_6d2,X
  cmp #$0A
  bcc _label_a09d
  inc a:temp_var_6d1,X
  clc
  adc #$06
  and #$0F
  sta a:temp_var_6d2,X
_label_a09d:
  dex
  bne _label_a08b
  lda a:temp_var_6cf
  tax
  clc
  adc temp_var_b1
  sta temp_var_b1
  txa
  clc
  adc temp_var_b2
  sta temp_var_b2
  txa
  and #$0F
  clc
  adc a:temp_var_5b9
  sta a:temp_var_5b9
  txa
  ror a
  ror a
  ror a
  ror a
  and #$0F
  clc
  adc a:temp_var_5b8
  sta a:temp_var_5b8
  ldx #$03
_label_a0c9:
  lda a:temp_var_5b6,X
  cmp #$0A
  bcc _label_a0db
  inc a:temp_var_5b5,X
  clc
  adc #$06
  and #$0F
  sta a:temp_var_5b6,X
_label_a0db:
  dex
  bne _label_a0c9
  ldx #$02
_label_a0e0:
  lda a:temp_var_6d2,X
  clc
  adc a:temp_var_5bc,X
  sta a:temp_var_5bc,X
  dex
  bpl _label_a0e0
  ldx #$04
_label_a0ef:
  lda a:temp_var_5ba,X
  cmp #$0A
  bcc _label_a101
  inc a:temp_var_5b9,X
  clc
  adc #$06
  and #$0F
  sta a:temp_var_5ba,X
_label_a101:
  dex
  bne _label_a0ef
  lda #$04
  sta a:$06D6
  sta a:$06DC
  lda #$01
  sta a:$06D7
  sta a:$06DD
  ldx #$00
_label_a116:
  lda a:temp_var_5b6,X
  tay
  lda a:_data_f1de_indexed,Y
  sta a:temp_var_6d8,X
  lda a:temp_var_6d2,X
  tay
  lda a:_data_f1de_indexed,Y
  sta a:temp_var_6de,X
  inx
  cpx #$04
  bcc _label_a116
  lda #$06
  sta a:temp_var_6e2
  lda #$01
  sta a:temp_var_6e3
  ldx #$00
_label_a13b:
  lda a:temp_var_5ba,X
  tay
  lda a:_data_f1de_indexed,Y
  sta a:temp_var_6e4,X
  inx
  cpx #$06
  bcc _label_a13b
  ldx temp_var_35
  ldy #$00
_label_a14e:
  lda a:_data_a170_indexed,Y
  sta a:ppu_update_flag,X
  inx
  iny
  cpy #$0C
  bcc _label_a14e
  stx temp_var_35
  lda #$00
  sta a:ppu_update_flag,X
  sta a:temp_var_6cf
  sta a:temp_var_6ce
  sta a:temp_var_6d0
  sta a:temp_var_6d1
  inc temp_var_b0
  rts

_data_a170_indexed:
.byte $32, $23, $d6, $06, $52, $23, $dc, $06, $3a, $23

_data_a17a:
.byte $e2

_data_a17b:
.byte $06

_label_a17c:
  lda frame_counter
  ror a
  bcc _label_a182
  rts
_label_a182:
  lda temp_var_69
  bne _label_a18f
  lda temp_var_ad
  cmp #$05
  bne _label_a18f
  jsr _func_a1e4
_label_a18f:
  lda temp_var_ae
  and #$03
  tax
  lda a:_data_b8f7_indexed,X
  sta temp_var_1b
  ldx temp_var_ad
  jsr _func_a207
  jsr _func_85dc
  lda #$00
  sta a:sprite_flag,X
  jsr _func_8535
  lda temp_var_69
  bne _label_a1b3
  dec temp_var_ad
  bne _label_a1b3
  inc temp_var_ae
_label_a1b3:
  lda temp_var_ab
  bne _label_a1b9
  inc temp_var_b0
_label_a1b9:
  inc temp_var_b0
  rts

_func_a1bc:
  lda temp_var_b4
  tax
  and #$0F
  tay
_label_a1c2:
  lda a:temp_var_5db,X
  and #$40
  bne _label_a1ce
  dex
  dey
  bpl _label_a1c2
  rts
_label_a1ce:
  txa
  cmp temp_var_b4
  beq _label_a1e3
  sec
  sbc temp_var_b4
  asl a
  asl a
  asl a
  asl a
  clc
  adc a:temp_var_399
  sta a:temp_var_399
  stx temp_var_b4
_label_a1e3:
  rts

_func_a1e4:
  ldy #$05
  lda #$23
  sta temp_var_1a
  lda #$56
  sta temp_var_19
  lda #$75
  sta temp_var_17
  lda #$F2
  sta temp_var_18
_label_a1f6:
  jsr _func_85dc
  inc temp_var_19
  inc temp_var_19
  dey
  bne _label_a1f6
  tya
  sta a:sprite_flag,X
  stx temp_var_34
  rts

_func_a207:
  lda #$23
  sta temp_var_1a
  lda #$56
  sta temp_var_19
  lda a:temp_var_6e9,X
  asl a
  tay
  clc
  adc temp_var_19
  sta temp_var_19
  tya
  asl a
  tay
  ldx temp_var_ae
  inx
  txa
  and #$02
  bne _label_a229
  tya
  clc
  adc #$14
  tay
_label_a229:
  lda #$9E
  sta temp_var_17
  lda #$F2
  sta temp_var_18
  tya
  clc
  adc temp_var_17
  sta temp_var_17
  bcc _label_a23b
  inc temp_var_18
_label_a23b:
  rts

_func_a23c:
  lda temp_var_b8
  bne _label_a251
  ldx temp_var_ae
  dex
  bmi _label_a251
  lda joypad2_state
  tay
  cmp #$84
  beq _label_a252
  tya
  cmp #$44
  beq _label_a252
_label_a251:
  rts
_label_a252:
  lda temp_var_b3
  beq _label_a25f
  lda a:temp_var_359
  beq _label_a26f
  lda #$00
  sta temp_var_b3
_label_a25f:
  ldx temp_var_b4
  bmi _label_a26f
  lda a:temp_var_5db,X
  and #$BF
  sta a:temp_var_5db,X
  lda #$FF
  sta temp_var_b4
_label_a26f:
  lda #$01
  sta temp_var_b8
  lda #$00
  sta temp_var_b7
  lda #$06
  sta temp_var_11
  lda #$01
  sta temp_var_12
  jsr update_display_elements
  lda #$B0
  sta a:temp_var_389
  lda #$98
  sta a:temp_var_399
  rts

_func_a28d:
  lda frame_counter
  ror a
  bcc _label_a293
  rts
_label_a293:
  lda temp_var_b7
  jsr jump_table_engine

  .word _label_a2a6
  .word _label_a2c4
  .word _label_a35d
  .word _func_9b8c
  .word _label_a3c1
  .word _func_9b8c
  .word _label_a422

_label_a2a6:
  jsr stop_all_music
  lda #$01
  sta a:temp_var_d2
  lda #$06
  sta a:audio_track
  jsr _func_de4b
  lda #$00
  sta a:temp_var_d2
  inc temp_var_b7
  lda #$F0
  sta temp_var_a9
  rts

_data_a2c2:
.byte $92

_data_a2c3:
.byte $06

_label_a2c4:
  dec temp_var_a9
  bne _label_a2d2
  jsr _func_a301
  inc temp_var_b7
  lda #$00
  sta temp_var_a9
  rts
_label_a2d2:
  lda frame_counter
  and #$04
  beq _label_a2db
  jmp _func_a301
_label_a2db:
  lda #$23
  sta temp_var_1a
  lda #$C4
  sta temp_var_19
  lda #$10
  sta temp_var_17
  lda #$FD
  sta temp_var_18
_label_a2eb:
  jsr _func_85f9
  lda temp_var_19
  clc
  adc #$08
  sta temp_var_19
  cmp #$F0
  bcc _label_a2eb
  ldx temp_var_35
  lda #$00
  sta a:ppu_update_flag,X
  rts

_func_a301:
  lda a:_data_a2c2
  sta temp_var_17
  lda a:_data_a2c3
  sta temp_var_18
  lda #$23
  sta temp_var_1a
  lda #$C4
  sta temp_var_19
  lda #$04
  sta temp_var_21
  ldy #$00
_label_a319:
  lda #$04
  sta a:temp_var_692,Y
  lda #$01
  iny
  sta a:temp_var_692,Y
  iny
  lda #$04
  sta temp_var_1f
  ldx temp_var_21
_label_a32b:
  lda a:temp_var_4e2,X
  sta a:temp_var_692,Y
  iny
  inx
  dec temp_var_1f
  bne _label_a32b
  jsr _func_85f9
  lda temp_var_17
  clc
  adc #$06
  sta temp_var_17
  bcc _label_a345
  inc temp_var_18
_label_a345:
  lda temp_var_21
  clc
  adc #$08
  sta temp_var_21
  clc
  adc #$C0
  sta temp_var_19
  cmp #$F0
  bcc _label_a319
  ldx temp_var_35
  lda #$00
  sta a:ppu_update_flag,X
  rts
_label_a35d:
  lda temp_var_a9
  tax
  tay
  lda a:temp_var_5db,X
_label_a364:
  bmi _label_a36a
  sta a:temp_var_5db,Y
  iny
_label_a36a:
  inx
  lda a:temp_var_5db,X
  bne _label_a364
  stx temp_var_21
  lda #$00
_label_a374:
  sta a:temp_var_5db,Y
  iny
  cpy temp_var_21
  bcc _label_a374
  ldx temp_var_a9
  stx temp_var_24
  ldx temp_var_24
_label_a382:
  lda a:temp_var_5db,X
  and #$07
  sta temp_var_1b
  asl a
  tax
  lda a:_data_f26b,X
  sta temp_var_17
  lda a:_data_f26b+1,X
  sta temp_var_18
  lda temp_var_24
  jsr _func_8511
  jsr _func_85dc
  jsr _func_8535
  inc temp_var_24
  ldx temp_var_24
  cpx temp_var_21
  bcc _label_a382
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  lda temp_var_a9
  clc
  adc #$10
  sta temp_var_a9
  cmp #$70
  bcc _label_a3c0
  inc temp_var_b7
  lda #$00
  sta temp_var_b0
_label_a3c0:
  rts
_label_a3c1:
  lda #$08
  sta temp_var_1f
_label_a3c5:
  jsr _func_85a4
  lda temp_var_39
  rol a
  rol a
  and #$7F
  cmp #$70
  bcs _label_a402
  tax
  lda a:temp_var_5db,X
  and #$07
  beq _label_a402
  stx temp_var_21
  jsr _func_85a4
  lda temp_var_39
  and #$03
  tay
  iny
  sty temp_var_1b
  tya
  sta a:temp_var_5db,X
  asl a
  tax
  lda a:_data_f26b,X
  sta temp_var_17
  lda a:_data_f26b+1,X
  sta temp_var_18
  lda temp_var_21
  jsr _func_8511
  jsr _func_85dc
  jsr _func_8535
_label_a402:
  dec temp_var_1f
  bne _label_a3c5
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  dec a:temp_var_399
  dec a:temp_var_399
  lda a:temp_var_399
  cmp #$F8
  bcc _label_a421
  inc temp_var_b7
  lda #$00
  sta a:temp_var_359
_label_a421:
  rts
_label_a422:
  lda #$00
  sta temp_var_b8
  sta temp_var_b7
  jsr stop_all_music
  lda #$01
  sta a:temp_var_d2
  lda a:temp_var_6a
  sta a:audio_track
  jsr _func_de4b
  lda #$00
  sta a:temp_var_d2
  dec temp_var_ae
  bne _label_a44d
  lda temp_var_ad
  bne _label_a44d
  jsr _func_a1e4
  lda #$00
  beq _label_a477
_label_a44d:
  lda temp_var_ae
  and #$03
  tax
  lda temp_var_ad
  bne _label_a459
  dex
  dec temp_var_ae
_label_a459:
  lda a:_data_b8f7_indexed,X
  sta temp_var_1b
  lda #$05
  sta temp_var_21
_label_a462:
  lda temp_var_ad
  cmp temp_var_21
  bcs _label_a477
  ldx temp_var_21
  jsr _func_a207
  jsr _func_85dc
  jsr _func_8535
  dec temp_var_21
  bne _label_a462
_label_a477:
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  lda temp_var_ad
  bne _label_a484
  inc temp_var_ae
_label_a484:
  rts

process_puzzle_input:
  lda frame_counter
  ror a
  bcs _label_a48b
  rts
_label_a48b:
  and #$1F
  bne _label_a498
  lda temp_var_c1
  eor temp_var_30
  sta temp_var_c1
  jmp _label_a499
_label_a498:
  rts
_label_a499:
  lda #$00
  asl a
  tax
  lda temp_var_c1
  beq _label_a4ae
  lda a:_data_a4ed_indexed,X
  sta temp_var_19
  lda a:_data_a4ed_indexed+1,X
  sta temp_var_1a
  jmp _label_a4b8
_label_a4ae:
  lda a:_data_a4dc_indexed,X
  sta temp_var_19
  lda a:_data_a4dc_indexed+1,X
  sta temp_var_1a
_label_a4b8:
  ldy #$00
  ldx temp_var_35
  lda #$04
  sta temp_var_1f
_label_a4c0:
  lda (temp_var_19),Y
  sta a:ppu_update_flag,X
  inx
  iny
  dec temp_var_1f
  bne _label_a4c0
  lda game_var_68
  beq _label_a4d4
  lda #$45
  sta a:temp_var_334,X
_label_a4d4:
  lda #$00
  sta a:ppu_update_flag,X
  stx temp_var_35
  rts

_data_a4dc_indexed:
.byte $de, $a4, $27, $23, $e2, $a4, $03, $03
.byte $60, $61, $62, $75, $74, $73, $7a, $7b
.byte $7d

_data_a4ed_indexed:
.byte $ef, $a4, $27, $23, $f3, $a4, $03, $03
.byte $60, $d2, $d3, $75, $d1, $d0, $cd, $ce
.byte $cf

_func_a4fe:
  lda temp_var_52
  beq _label_a520
  lda temp_var_3b
  and #$01
  beq _label_a50d
  inc temp_var_45
  jmp _label_a515
_label_a50d:
  lda temp_var_3b
  and #$02
  beq _label_a51d
  dec temp_var_45
_label_a515:
  dec temp_var_52
  bne _label_a51d
  lda #$00
  sta temp_var_3b
_label_a51d:
  jmp _label_a60e
_label_a520:
  lda joypad1_state
  and #$08
  bne _label_a52c
  lda #$00
  sta temp_var_c3
  beq _label_a542
_label_a52c:
  inc temp_var_c3
  lda temp_var_c3
  cmp #$08
  bcc _label_a53e
  lda #$00
  sta temp_var_c3
  inc a:temp_var_5a4
  inc a:temp_var_5a4
_label_a53e:
  lda #$00
  sta temp_var_c4
_label_a542:
  lda temp_var_c4
  bne _label_a550
  lda temp_var_32
  sta temp_var_c4
  dec temp_var_3c
  dec temp_var_46
  dec temp_var_46
_label_a550:
  dec temp_var_c4
  lda temp_var_3c
  bne _label_a56c
  lda #$08
  sta temp_var_3c
  lda temp_var_49
  sta temp_var_20
  dec temp_var_20
  lda temp_var_44
  sta temp_var_23
  jsr _func_a658
  beq _label_a56c
  inc temp_var_5a
  rts
_label_a56c:
  lda joypad1_state
  and #$03
  bne _label_a575
  jmp _label_a60e
_label_a575:
  cmp #$03
  bne _label_a580
  lda #$00
  sta temp_var_3b
  jmp _label_a60e
_label_a580:
  sta temp_var_3b
  lda joypad1_state
  and #$01
  beq _label_a591
  lda temp_var_49
  clc
  adc #$10
  and #$F0
  sta temp_var_20
_label_a591:
  lda joypad1_state
  and #$02
  beq _label_a5a0
  lda temp_var_49
  sec
  sbc #$10
  and #$F0
  sta temp_var_20
_label_a5a0:
  lda temp_var_49
  and #$0F
  ora temp_var_20
  sta temp_var_20
  lda temp_var_3c
  cmp #$05
  bcc _label_a5c9
  lda temp_var_49
  sta temp_var_1c
  and #$0F
  cmp #$0E
  bcc _label_a5be
  lda temp_var_49
  eor #$10
  sta temp_var_1c
_label_a5be:
  lda temp_var_1c
  and #$10
  beq _label_a5e1
  inc temp_var_20
  jmp _label_a5e1
_label_a5c9:
  lda temp_var_49
  sta temp_var_1c
  and #$0F
  cmp #$0E
  bcc _label_a5d9
  lda temp_var_49
  eor #$10
  sta temp_var_1c
_label_a5d9:
  lda temp_var_1c
  and #$10
  bne _label_a5e1
  dec temp_var_20
_label_a5e1:
  lda temp_var_44
  sta temp_var_23
  jsr _func_a658
  beq _label_a5f3
  lda #$00
  sta temp_var_3b
  sta temp_var_52
  jmp _label_a60e
_label_a5f3:
  lda #$00
  sta temp_var_c4
  lda #$10
  sta temp_var_52
  lda temp_var_3c
  cmp #$05
  bcc _label_a609
  sec
  sbc #$04
  sta temp_var_3c
  jmp _label_a60e
_label_a609:
  clc
  adc #$04
  sta temp_var_3c
_label_a60e:
  lda temp_var_44
  sta temp_var_23
  and #$01
  beq _label_a637
  lda joypad1_press
  and #$80
  beq _label_a61e
  dec temp_var_23
_label_a61e:
  lda joypad1_press
  and #$40
  beq _label_a626
  inc temp_var_23
_label_a626:
  lda temp_var_23
  and #$03
  sta temp_var_23
  lda temp_var_49
  sta temp_var_20
  jsr _func_a658
  jsr _func_b1e2
  rts
_label_a637:
  lda joypad1_press
  and #$80
  beq _label_a63f
  inc temp_var_23
_label_a63f:
  lda joypad1_press
  and #$40
  beq _label_a647
  dec temp_var_23
_label_a647:
  lda temp_var_23
  and #$03
  sta temp_var_23
  lda temp_var_49
  sta temp_var_20
  jsr _func_a658
  jsr _func_b1e2
  rts

_func_a658:
  lda temp_var_20
  and #$F0
  sta temp_var_21
  lda temp_var_20
  and #$0F
  sta temp_var_22
  lda #$04
  sta temp_var_1f
  ldx #$00
  lda temp_var_23
  asl a
  asl a
  sta temp_var_25
_label_a670:
  ldy temp_var_25
  lda (temp_var_42),Y
  sta temp_var_1e
  lda temp_var_21
  sta temp_var_1c
  lda temp_var_22
  cmp #$0E
  bcc _label_a687
  lda temp_var_21
  clc
  adc #$10
  sta temp_var_1c
_label_a687:
  lda temp_var_1c
  and #$10
  beq _label_a695
  lda temp_var_1e
  and #$10
  beq _label_a695
  inc temp_var_1e
_label_a695:
  lda temp_var_1e
  and #$F0
  clc
  adc temp_var_21
  sta temp_var_1d
  cmp #$70
  bne _label_a6a5
  lda #$FF
  rts
_label_a6a5:
  lda temp_var_1e
  and #$0F
  clc
  adc temp_var_22
  sta temp_var_1c
  and #$0F
  cmp #$0E
  bcc _label_a6b7
_label_a6b4:
  lda #$FF
  rts
_label_a6b7:
  lda temp_var_1c
  clc
  adc temp_var_1d
  cmp #$70
  bcs _label_a6b4
  tay
  lda a:temp_var_400,Y
  and #$7F
  beq _label_a6c9
  rts
_label_a6c9:
  tya
  sta temp_var_c5,X
  inx
  inc temp_var_25
  dec temp_var_1f
  bne _label_a670
  lda #$04
  sta temp_var_1f
  ldx #$00
_label_a6d9:
  lda temp_var_c5,X
  sta temp_var_4a,X
  inx
  dec temp_var_1f
  bne _label_a6d9
  lda temp_var_20
  sta temp_var_49
  lda temp_var_23
  sta temp_var_44
  lda #$00
  rts

_func_a6ed:
  ldx #$00
  stx temp_var_21
_label_a6f1:
  ldy temp_var_4a,X
  lda temp_var_4e,X
  sta temp_var_1b
  sta a:temp_var_400,Y
  inc temp_var_21
  asl a
  tax
  lda a:_data_f26b,X
  sta temp_var_17
  lda a:_data_f26b+1,X
  sta temp_var_18
  tya
  jsr _func_8511
  jsr _func_85dc
  jsr _func_8535
  ldx temp_var_21
  cpx #$04
  bcc _label_a6f1
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  rts
_label_a720:
  lda temp_var_5b
  cmp #$00
  bne _label_a75c
  ldx #$00
  stx temp_var_54
_label_a72a:
  stx temp_var_21
  lda temp_var_4a,X
  sta temp_var_20
  dec temp_var_20
_label_a732:
  lda temp_var_20
  and #$0F
  cmp #$0E
  bcs _label_a752
  ldy temp_var_20
  lda a:temp_var_400,Y
  bne _label_a752
  lda #$80
  sta a:temp_var_400,Y
  tya
  ldx temp_var_54
  sta a:temp_var_568,X
  inc temp_var_54
  dec temp_var_20
  bpl _label_a732
_label_a752:
  ldx temp_var_21
  inx
  cpx #$04
  bcc _label_a72a
  inc temp_var_5b
  rts
_label_a75c:
  lda frame_counter
  ror a
  bcs _label_a762
  rts
_label_a762:
  lda #$DA
  sta temp_var_17
  lda #$F2
  sta temp_var_18
  lda #$0C
  sta temp_var_1f
  ldy #$00
_label_a770:
  dec temp_var_54
  bpl _label_a78c
  inc temp_var_5a
  lda temp_var_5e
  bne _label_a77c
  inc temp_var_5a
_label_a77c:
  lda #$00
  ldy temp_var_34
  sta temp_var_5b
  sta a:sprite_flag,Y
  sta temp_var_3b
  lda #$03
  sta temp_var_52
  rts
_label_a78c:
  ldx temp_var_54
  lda a:temp_var_568,X
  jsr _func_8511
  jsr _func_85dc
  dec temp_var_1f
  bpl _label_a770
  ldy temp_var_34
  lda #$00
  sta a:sprite_flag,Y
  rts
_label_a7a3:
  lda temp_var_5b
  jsr jump_table_engine

  .word _label_a7b0
  .word _label_a7bb
  .word _label_a7d5
  .word _label_a80e

_label_a7b0:
  lda #$0A
  sta screen_mode
  lda #$00
  sta temp_var_66
  inc temp_var_5b
  rts
_label_a7bb:
  lda #$00
  sta a:temp_var_358
  sta a:temp_var_35a
  sta a:$035B
  sta a:$035C
  sta a:$035D
  lda #$0A
  sta temp_var_54
  inc temp_var_5b
  jmp _label_e275
_label_a7d5:
  lda frame_counter
  ror a
  bcs _func_a7db
  rts

_func_a7db:
  lda #$75
  sta temp_var_17
  lda #$F2
  sta temp_var_18
  lda temp_var_54
_label_a7e5:
  sta temp_var_52
  jsr _func_8511
  jsr _func_85dc
  lda temp_var_52
  clc
  adc #$10
  cmp #$70
  bcc _label_a7e5
  lda #$00
  sta a:sprite_flag,X
  dec temp_var_54
  bpl _label_a80d
  inc temp_var_5b
  ldy #$00
  lda #$00
_label_a805:
  sta a:temp_var_400,Y
  iny
  cpy #$70
  bcc _label_a805
_label_a80d:
  rts
_label_a80e:
  lda frame_counter
  ror a
  bcs _label_a814
  rts
_label_a814:
  ldx temp_var_35
  ldy #$00
_label_a818:
  lda a:_data_a843_indexed,Y
  sta a:ppu_update_flag,X
  inx
  iny
  cpy #$08
  bcc _label_a818
  lda #$00
  sta a:ppu_update_flag,X
  lda game_var_68
  beq _label_a834
  ldy temp_var_35
  lda #$A7
  sta a:ppu_update_flag,Y
_label_a834:
  stx temp_var_35
  lda #$01
  sta game_state_8c
  lda #$00
  sta temp_var_59
  sta temp_var_58
  jmp _func_a85e

_data_a843_indexed:
.byte $a9, $21, $69, $fc, $d9, $23, $73, $fc

_func_a84b:
  lda #$00
  sta temp_var_5b
  lda #$0A
  sta temp_var_54
  rts

_func_a854:
  jsr _func_a7db
  lda temp_var_5b
  beq _label_a85d
  inc temp_var_66
_label_a85d:
  rts

_func_a85e:
  lda #$00
  tax
_label_a861:
  sta temp_var_5a,X
  inx
  cpx #$0A
  bcc _label_a861
  lda #$FF
  sta temp_var_5f
  rts

_func_a86d:
  lda temp_var_58
  bne _label_a889
  jsr _func_85a4
  lda temp_var_39
  and #$03
  tay
  ldx #$00
_label_a87b:
  lda a:_data_a8b2_indexed,Y
  sta a:temp_var_5d4,X
  iny
  inx
  cpx #$05
  bcc _label_a87b
  stx temp_var_58
_label_a889:
  ldx temp_var_58
  lda a:temp_var_5d3,X
  clc
  adc #$07
  sta temp_var_11
  lda #$00
  sta temp_var_12
  jsr update_display_elements
  jsr _func_85a4
  lda temp_var_39
  and #$03
  sta temp_var_5e
  inc temp_var_5e
  ldx temp_var_5f
  bmi _label_a8b1
  lda a:temp_var_400,X
  and #$BF
  sta a:temp_var_400,X
_label_a8b1:
  rts

_data_a8b2_indexed:
.byte $02, $00, $04, $03, $01, $02, $00, $04, $03

_func_a8bb:
  lda #$02
  sta temp_var_5e
  lda #$05
  sta temp_var_11
  lda #$02
  sta temp_var_12
  jsr update_display_elements
  lda #$00
  sta temp_var_5d
  ldx temp_var_5f
  bmi _label_a8e9
  lda a:temp_var_400,X
  and #$BF
  sta a:temp_var_400,X
  lda #$FF
  sta temp_var_5f
  lda #$00
  sta temp_var_11
  lda #$00
  sta temp_var_12
  jsr update_display_elements
_label_a8e9:
  rts
_label_a8ea:
  lda frame_counter
  ror a
  bcs _label_a8f0
  rts
_label_a8f0:
  lda temp_var_5b
  bne _label_a903
  inc temp_var_5b
  lda #$01
  sta a:temp_var_d8
  lda #$05
  sta a:temp_var_d7
  jmp _func_e216
_label_a903:
  cmp #$01
  bne _label_a951
  lda #$05
  sta temp_var_11
  lda #$03
  sta temp_var_12
  jsr update_display_elements
  lda temp_var_3b
  asl a
  tax
  lda a:_data_fce0_indexed,X
  clc
  adc a:temp_var_38a
  sta a:$038B
  lda a:_data_fce0_indexed+1,X
  clc
  adc a:temp_var_39a
  sta a:$039B
  lda frame_counter
  ror a
  and #$03
  sta temp_var_20
  lda a:temp_var_3aa
  and #$FC
  ora temp_var_20
  sta a:temp_var_3aa
  sta a:$03AB
  inc temp_var_3b
  lda temp_var_3b
  cmp #$18
  bne _label_a950
  lda #$00
  sta temp_var_3b
  dec temp_var_52
  bne _label_a950
  inc temp_var_5b
_label_a950:
  rts
_label_a951:
  cmp #$02
  bne _label_a9c2
  lda temp_var_4a
  sta a:temp_var_522
  tax
  jsr _func_85a4
  lda temp_var_39
  and #$03
  sta temp_var_5e
  inc temp_var_5e
  lda temp_var_5e
  sta a:temp_var_400,X
  ldy #$01
  sty temp_var_25
  lda a:temp_var_522
  and #$10
  beq _label_a97a
  lda #$07
  sta temp_var_25
_label_a97a:
  lda #$01
  sta temp_var_21
  lda #$06
  sta temp_var_1f
_label_a982:
  ldy temp_var_25
  lda a:_data_fcd3_indexed,Y
  inc temp_var_25
  clc
  adc a:temp_var_522
  tax
  and #$0F
  cmp #$0D
  bcs _label_a9b4
  txa
  and #$F0
  cmp #$70
  bcs _label_a9b4
  lda a:temp_var_400,X
  and #$07
  bne _label_a9a7
  sta a:temp_var_400,X
  beq _label_a9ac
_label_a9a7:
  lda temp_var_5e
  sta a:temp_var_400,X
_label_a9ac:
  txa
  ldx temp_var_21
  sta a:temp_var_522,X
  inc temp_var_21
_label_a9b4:
  dec temp_var_1f
  bne _label_a982
  ldx temp_var_21
  lda #$FF
  sta a:temp_var_522,X
  inc temp_var_5b
  rts
_label_a9c2:
  cmp #$03
  bne _label_aa0d
  ldy #$00
  sty temp_var_22
_label_a9ca:
  ldy temp_var_22
  lda a:temp_var_522,Y
  bmi _label_a9f3
  sta temp_var_21
  jsr _func_8511
  ldx temp_var_21
  lda a:temp_var_400,X
  sta temp_var_1b
  asl a
  tax
  lda a:_data_f26b,X
  sta temp_var_17
  lda a:_data_f26b+1,X
  sta temp_var_18
  jsr _func_85dc
  jsr _func_8535
  inc temp_var_22
  bpl _label_a9ca
_label_a9f3:
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  lda #$00
  sta temp_var_11
  lda #$02
  sta temp_var_12
  jsr update_display_elements
  inc temp_var_12
  jsr update_display_elements
  inc temp_var_5b
  rts
_label_aa0d:
  inc temp_var_5b
  lda temp_var_5b
  cmp #$0F
  bcc _label_aa1f
  lda #$00
  sta temp_var_5b
  sta temp_var_60
  sta temp_var_5e
  inc temp_var_5a
_label_aa1f:
  rts
_label_aa20:
  lda temp_var_66
  jsr jump_table_engine

  .word _label_aa38
  .word _label_ab18
  .word _label_ab65
  .word _label_ab82
  .word _label_abb6
  .word _label_ac05
  .word _label_ac1b
  .word _label_ad96
  .word _label_adea

_data_aa37_indexed:
.byte $01

_label_aa38:
  lda #$00
  sta PPU_CTRL
  sta PPU_MASK
  ldx #$00
  lda a:_data_aa37_indexed,X
  sta a:_data_aa37_indexed,X
  lda #$F1
  sta temp_var_12
  lda #$EE
  sta temp_var_11
  jsr load_palette
  lda temp_var_56
  asl a
  tax
  lda a:_data_f429,X
  sta temp_var_37
  lda a:_data_f429+1,X
  sta temp_var_38
  lda game_var_68
  bne _label_aaa7
  ldy #$07
  lda #$22
  sta temp_var_1a
  lda #$76
  sta temp_var_19
  ldx #$06
_label_aa71:
  stx temp_var_21
  lda PPU_STATUS
  lda temp_var_1a
  sta PPU_ADDR
  lda temp_var_19
  sta PPU_ADDR
  lda #$FF
_label_aa82:
  sta PPU_DATA
  dec temp_var_21
  bne _label_aa82
  lda temp_var_19
  clc
  adc #$20
  sta temp_var_19
  bcc _label_aa94
  inc temp_var_1a
_label_aa94:
  dey
  bne _label_aa71
  lda #$3A
  sta temp_var_19
  lda #$21
  sta temp_var_1a
  jsr _func_aca2
  lda #$00
  sta a:ppu_update_flag,X
_label_aaa7:
  lda game_var_68
  beq _label_aae6
  lda PPU_STATUS
  lda temp_ptr_hi
  ora #$04
  sta PPU_CTRL
  lda #$24
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR
  tay
_label_aac0:
  lda a:_data_ad37_indexed,Y
  sta PPU_DATA
  iny
  cpy #$1E
  bcc _label_aac0
  ldx #$C0
  ldy #$55
_label_aacf:
  lda PPU_STATUS
  lda #$27
  sta PPU_ADDR
  stx PPU_ADDR
  sty PPU_DATA
  txa
  clc
  adc #$08
  tax
  cmp #$F8
  bne _label_aacf
_label_aae6:
  lda #$02
  jsr _func_8ee3
  jsr _func_b21f
  inc temp_var_66
  jsr stop_all_music
  lda #$01
  sta a:temp_var_d2
  lda temp_var_6a
  sta a:audio_track
  jsr _func_de4b
  lda #$00
  sta a:temp_var_d2
  lda #$88
  sta temp_ptr_hi
  lda ppu_mask_copy
  ora #$18
  sta ppu_mask_copy
  lda game_var_68
  beq _label_ab17
  lda #$0C
  sta scroll_x
_label_ab17:
  rts
_label_ab18:
  lda #$87
  sta temp_var_19
  lda #$21
  sta temp_var_1a
  lda #$8F
  sta temp_var_17
  lda #$FC
  sta temp_var_18
  lda game_var_68
  beq _label_ab30
  dec temp_var_19
  dec temp_var_19
_label_ab30:
  jsr _func_85f9
  lda #$D9
  sta temp_var_19
  lda #$23
  sta temp_var_1a
  lda #$73
  sta temp_var_17
  lda #$FC
  sta temp_var_18
  jsr _func_85f9
  lda #$8C
  sta temp_var_19
  lda #$21
  sta temp_var_1a
  lda game_var_68
  beq _label_ab56
  dec temp_var_19
  dec temp_var_19
_label_ab56:
  jsr _func_aca2
  lda #$00
  sta a:ppu_update_flag,X
  inc temp_var_66
  lda #$00
  sta temp_var_52
  rts
_label_ab65:
  lda joypad1_press
  and #$10
  bne _label_ab74
  dec temp_var_52
  bne _label_ab73
  lda #$06
  sta temp_var_66
_label_ab73:
  rts
_label_ab74:
  lda #$01
  sta pause_flag
  jsr update_pause_display
  inc temp_var_66
  lda #$00
  sta temp_var_54
  rts
_label_ab82:
  lda joypad1_press
  beq _label_ab9b
  ldx temp_var_54
  bmi _label_ab9c
  lda a:_data_abb2_indexed,X
  cmp joypad1_press
  bne _label_ab9c
  inc temp_var_54
  lda temp_var_54
  cmp #$04
  bcc _label_ab9b
  inc temp_var_66
_label_ab9b:
  rts
_label_ab9c:
  lda #$FF
  sta temp_var_54
  lda joypad1_press
  and #$10
  beq _label_ab9b
  lda #$00
  sta pause_flag
  jsr update_pause_display
  lda #$06
  sta temp_var_66
  rts

_data_abb2_indexed:
.byte $08, $01, $04, $02

_label_abb6:
  ldy #$06
  lda temp_var_69
  beq _label_abbd
  dey
_label_abbd:
  sty temp_var_20
  lda joypad1_press
  and #$10
  beq _label_abc8
  inc temp_var_66
  rts
_label_abc8:
  lda joypad1_press
  and #$80
  beq _label_abda
  inc temp_var_57
  lda temp_var_57
  cmp temp_var_20
  bcc _label_abda
  lda #$00
  sta temp_var_57
_label_abda:
  lda joypad1_press
  and #$40
  beq _label_abec
  inc temp_var_56
  lda temp_var_56
  cmp #$04
  bcc _label_abec
  lda #$00
  sta temp_var_56
_label_abec:
  lda #$8C
  sta temp_var_19
  lda #$21
  sta temp_var_1a
  lda game_var_68
  beq _label_abfc
  dec temp_var_19
  dec temp_var_19
_label_abfc:
  jsr _func_aca2
  lda #$00
  sta a:ppu_update_flag,X
  rts
_label_ac05:
  lda joypad1_press
  and #$10
  beq _label_ac1a
  lda #$00
  sta pause_flag
  jsr clear_sprites
  lda #$09
  sta screen_mode
  lda #$05
  sta temp_var_66
_label_ac1a:
  rts
_label_ac1b:
  lda #$08
  ldy game_state_8c
  beq _label_ac23
  lda #$04
_label_ac23:
  sta temp_var_1f
  ldx #$00
  ldy #$00
_label_ac29:
  lda a:_data_ac92_indexed,Y
  sta a:ppu_update_flag,X
  inx
  iny
  dec temp_var_1f
  bne _label_ac29
  stx temp_var_35
  lda game_var_68
  beq _label_ac41
  dec a:ppu_update_flag
  dec a:ppu_update_flag
_label_ac41:
  lda game_var_68
  bne _label_ac54
  lda #$3A
  sta temp_var_19
  lda #$21
  sta temp_var_1a
  jsr _func_aca2
  lda #$01
  sta game_state_8d
_label_ac54:
  ldx temp_var_35
  lda game_state_8d
  bne _label_ac68
  ldy #$08
_label_ac5c:
  lda a:_data_ac92_indexed,Y
  sta a:ppu_update_flag,X
  inx
  iny
  cpy #$10
  bcc _label_ac5c
_label_ac68:
  lda #$00
  sta a:ppu_update_flag,X
  lda temp_var_56
  asl a
  tax
  lda a:_data_f429,X
  sta temp_var_37
  lda a:_data_f429+1,X
  sta temp_var_38
  ldx temp_var_57
  lda a:_data_fccd_indexed,X
  sta temp_var_32
  sta temp_var_33
  lda #$00
  sta temp_var_66
  lda temp_var_69
  bne _label_ac8f
  sta screen_mode
  rts
_label_ac8f:
  inc screen_mode
  rts

_data_ac92_indexed:
.byte $67, $21, $7d, $fc, $d9, $23, $78, $fc, $97, $21, $7d, $fc, $dd, $23, $78, $fc

_func_aca2:
  lda #$03
  sta a:temp_var_5c6
  lda #$01
  sta a:temp_var_5c7
  ldy temp_var_56
  lda a:_data_f1df_indexed,Y
  sta a:temp_var_5c8
  lda #$D4
  sta a:$05C9
  ldy temp_var_57
  lda a:_data_f1df_indexed,Y
  sta a:$05CA
  lda #$C6
  sta temp_var_17
  lda #$05
  sta temp_var_18
  jmp _func_85f9
_label_accc:
  lda #$00
  sta PPU_CTRL
  lda ppu_mask_copy
  and #$E7
  sta PPU_MASK
  sta ppu_mask_copy
  jsr clear_sprites
  lda game_var_68
  asl a
  tax
  lda a:_data_f674,X
  sta temp_var_11
  lda a:_data_f674+1,X
  sta temp_var_12
  jsr load_graphics_data
  lda game_var_68
  asl a
  tax
  lda a:_data_faff,X
  sta temp_var_11
  lda a:_data_faff+1,X
  sta temp_var_12
  jsr _func_84de
  lda game_var_68
  bne _label_ad16
  lda PPU_STATUS
  lda #$21
  sta PPU_ADDR
  lda #$3C
  sta PPU_ADDR
  lda a:_data_f1de_indexed,X
  sta PPU_DATA
_label_ad16:
  lda a:_data_fccd_indexed,X
  sta temp_var_32
  sta temp_var_33
  lda #$00
  sta z:$47
  lda #$04
  sta z:$48
  lda temp_var_69
  beq _label_ad34
  ldx #$00
_label_ad2b:
  txa
  sta a:temp_var_5d4,X
  inx
  cpx #$05
  bcc _label_ad2b
_label_ad34:
  inc screen_mode
  rts

_data_ad37_indexed:
.byte $ff, $24, $21, $22, $21, $22, $21, $22, $21, $22, $21, $22, $21, $22, $21, $22
.byte $21, $22, $21, $22, $21, $22, $21, $22, $21, $22, $21, $22, $21, $22

_label_ad55:
  lda temp_var_66
  jsr jump_table_engine

  .word _label_ad66
  .word _label_ad96
  .word _label_adea
  .word _label_9cbb
  .word _label_9cf8
  .word _label_9d4c

_label_ad66:
  lda game_state_8c
  beq _label_ad6f
  lda #$03
  sta temp_var_66
  rts
_label_ad6f:
  jsr _func_85a4
  and #$06
  sta temp_var_20
  lda temp_var_57
  asl a
  asl a
  asl a
  clc
  adc temp_var_20
  tax
  lda a:_data_fd16,X
  sta temp_var_4a
  lda a:_data_fd16+1,X
  sta z:$4B
  lda #$00
  sta temp_var_52
  sta temp_var_54
  inc temp_var_66
  lda #$00
  sta game_state_var
  rts
_label_ad96:
  ldx temp_var_52
  ldy temp_var_54
  lda (temp_var_4a),Y
  beq _label_add1
  sta a:temp_var_400,X
  sta temp_var_1b
  txa
  jsr _func_8511
  lda temp_var_1b
  bpl _label_adb9
  lda #$DA
  sta temp_var_17
  lda #$F2
  sta temp_var_18
  lda #$01
  sta temp_var_1b
  bne _label_adc5
_label_adb9:
  asl a
  tax
  lda a:_data_f26b,X
  sta temp_var_17
  lda a:_data_f26b+1,X
  sta temp_var_18
_label_adc5:
  jsr _func_85dc
  jsr _func_8535
  inc temp_var_54
  inc temp_var_52
  bpl _label_ad96
_label_add1:
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  inc temp_var_54
  lda temp_var_52
  and #$F0
  clc
  adc #$10
  sta temp_var_52
  cmp #$70
  bcc _label_ade9
  inc temp_var_66
_label_ade9:
  rts
_label_adea:
  lda temp_var_57
  sta temp_var_58
  ldx temp_var_56
  stx temp_var_59
  lda a:_data_b8f7_indexed,X
  sta temp_var_1b
  jsr _func_b923
  ldx temp_var_57
  beq _label_ae16
  stx temp_var_21
_label_ae00:
  jsr _func_b94c
  jsr _func_85dc
  jsr _func_8535
  dec temp_var_21
  ldx temp_var_21
  bne _label_ae00
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
_label_ae16:
  lda temp_var_57
  clc
  adc #$07
  sta temp_var_11
  lda #$00
  sta temp_var_12
  jsr update_display_elements
  ldx game_var_68
  lda a:_data_ae4e_indexed,X
  sta a:temp_var_388
  lda #$1C
  sta a:temp_var_398
  ldx #$30
  lda a:temp_var_400,X
  ora #$40
  sta a:temp_var_400,X
  stx temp_var_5f
  inc temp_var_66
  inc temp_var_58
  lda game_var_68
  bne _label_ae4d
  lda #$00
  sta temp_var_66
  sta screen_mode
  sta temp_var_54
_label_ae4d:
  rts

_data_ae4e_indexed:
.byte $54, $38

_func_ae50:
  lda temp_var_63
  bne _label_ae65
  ldx temp_var_59
  dex
  bmi _label_ae65
  lda joypad1_state
  tay
  cmp #$84
  beq _label_ae66
  tya
  cmp #$44
  beq _label_ae66
_label_ae65:
  rts
_label_ae66:
  lda temp_var_5e
  beq _label_ae73
  lda a:temp_var_358
  beq _label_ae83
  lda #$00
  sta temp_var_5e
_label_ae73:
  ldx temp_var_5f
  bmi _label_ae83
  lda a:temp_var_400,X
  and #$BF
  sta a:temp_var_400,X
  lda #$FF
  sta temp_var_5f
_label_ae83:
  lda #$01
  sta temp_var_63
  lda #$00
  sta temp_var_62
  lda #$06
  sta temp_var_11
  lda #$00
  sta temp_var_12
  jsr update_display_elements
  lda game_var_68
  beq _label_ae9f
  lda #$28
  sta a:temp_var_388
_label_ae9f:
  rts

_func_aea0:
  lda frame_counter
  ror a
  bcs _label_aea6
  rts
_label_aea6:
  lda temp_var_62
  jsr jump_table_engine

  .word _label_aeb9
  .word _label_aed5
  .word _label_af78
  .word _func_b98b
  .word _label_afdc
  .word _func_b98b
  .word _label_b03d

_label_aeb9:
  jsr stop_all_music
  lda #$01
  sta a:temp_var_d2
  lda #$06
  sta a:audio_track
  jsr _func_de4b
  lda #$00
  sta a:temp_var_d2
  inc temp_var_62
  lda #$F0
  sta temp_var_52
  rts
_label_aed5:
  dec temp_var_52
  bne _label_aee3
  jsr _func_af18
  inc temp_var_62
  lda #$00
  sta temp_var_52
  rts
_label_aee3:
  lda frame_counter
  and #$04
  beq _label_aeec
  jmp _func_af18
_label_aeec:
  lda #$23
  sta temp_var_1a
  lda #$C0
  sta temp_var_19
  lda game_var_68
  bne _label_aefa
  inc temp_var_19
_label_aefa:
  lda #$10
  sta temp_var_17
  lda #$FD
  sta temp_var_18
_label_af02:
  jsr _func_85f9
  lda temp_var_19
  clc
  adc #$08
  sta temp_var_19
  cmp #$F0
  bcc _label_af02
  ldx temp_var_35
  lda #$00
  sta a:ppu_update_flag,X
  rts

_func_af18:
  lda #$68
  sta temp_var_17
  lda #$05
  sta temp_var_18
  lda #$23
  sta temp_var_1a
  lda #$C0
  sta temp_var_19
  ldy #$00
  sty temp_var_21
  lda game_var_68
  bne _label_af34
  inc temp_var_19
  inc temp_var_21
_label_af34:
  lda #$04
  sta a:temp_var_568,Y
  lda #$01
  iny
  sta a:temp_var_568,Y
  iny
  lda #$04
  sta temp_var_1f
  ldx temp_var_21
_label_af46:
  lda a:temp_var_4e2,X
  sta a:temp_var_568,Y
  iny
  inx
  dec temp_var_1f
  bne _label_af46
  jsr _func_85f9
  lda temp_var_17
  clc
  adc #$06
  sta temp_var_17
  bcc _label_af60
  inc temp_var_18
_label_af60:
  lda temp_var_21
  clc
  adc #$08
  sta temp_var_21
  clc
  adc #$C0
  sta temp_var_19
  cmp #$F0
  bcc _label_af34
  ldx temp_var_35
  lda #$00
  sta a:ppu_update_flag,X
  rts
_label_af78:
  lda temp_var_52
  tax
  tay
  lda a:temp_var_400,X
_label_af7f:
  bmi _label_af85
  sta a:temp_var_400,Y
  iny
_label_af85:
  inx
  lda a:temp_var_400,X
  bne _label_af7f
  stx temp_var_21
  lda #$00
_label_af8f:
  sta a:temp_var_400,Y
  iny
  cpy temp_var_21
  bcc _label_af8f
  ldx temp_var_52
  stx temp_var_24
  ldx temp_var_24
_label_af9d:
  lda a:temp_var_400,X
  and #$07
  sta temp_var_1b
  asl a
  tax
  lda a:_data_f26b,X
  sta temp_var_17
  lda a:_data_f26b+1,X
  sta temp_var_18
  lda temp_var_24
  jsr _func_8511
  jsr _func_85dc
  jsr _func_8535
  inc temp_var_24
  ldx temp_var_24
  cpx temp_var_21
  bcc _label_af9d
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  lda temp_var_52
  clc
  adc #$10
  sta temp_var_52
  cmp #$70
  bcc _label_afdb
  inc temp_var_62
  lda #$00
  sta temp_var_5b
_label_afdb:
  rts
_label_afdc:
  lda #$08
  sta temp_var_1f
_label_afe0:
  jsr _func_85a4
  lda temp_var_39
  rol a
  rol a
  and #$7F
  cmp #$70
  bcs _label_b01d
  tax
  lda a:temp_var_400,X
  and #$07
  beq _label_b01d
  stx temp_var_21
  jsr _func_85a4
  lda temp_var_39
  and #$03
  tay
  iny
  sty temp_var_1b
  tya
  sta a:temp_var_400,X
  asl a
  tax
  lda a:_data_f26b,X
  sta temp_var_17
  lda a:_data_f26b+1,X
  sta temp_var_18
  lda temp_var_21
  jsr _func_8511
  jsr _func_85dc
  jsr _func_8535
_label_b01d:
  dec temp_var_1f
  bne _label_afe0
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  dec a:temp_var_398
  dec a:temp_var_398
  lda a:temp_var_398
  cmp #$F8
  bcc _label_b03c
  inc temp_var_62
  lda #$00
  sta a:temp_var_358
_label_b03c:
  rts
_label_b03d:
  lda #$00
  sta temp_var_63
  sta temp_var_62
  jsr stop_all_music
  lda #$01
  sta a:temp_var_d2
  lda temp_var_6a
  sta a:audio_track
  jsr _func_de4b
  lda #$00
  sta a:temp_var_d2
  dec temp_var_59
  bne _label_b067
  lda temp_var_58
  bne _label_b067
  jsr _func_b923
  lda #$00
  beq _label_b091
_label_b067:
  lda temp_var_59
  and #$03
  tax
  lda temp_var_58
  bne _label_b073
  dex
  dec temp_var_59
_label_b073:
  lda a:_data_b8f7_indexed,X
  sta temp_var_1b
  lda #$05
  sta temp_var_21
_label_b07c:
  lda temp_var_58
  cmp temp_var_21
  bcs _label_b091
  ldx temp_var_21
  jsr _func_b94c
  jsr _func_85dc
  jsr _func_8535
  dec temp_var_21
  bne _label_b07c
_label_b091:
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  lda temp_var_58
  bne _label_b09e
  inc temp_var_59
_label_b09e:
  rts

process_menu_state:
  lda temp_var_63
  beq _label_b0af
  lda temp_var_5a
  bne _label_b0af
  jsr _func_aea0
  lda #$00
  sta temp_var_5a
  rts
_label_b0af:
  lda temp_var_69
  bne _label_b0b6
  jsr _func_ae50
_label_b0b6:
  lda temp_var_5f
  bmi _label_b0c4
  lda temp_var_69
  bne _label_b0c4
  lda frame_counter
  bne _label_b0c4
  inc temp_var_61
_label_b0c4:
  lda temp_var_5a
  jsr jump_table_engine

  .word _label_b0db
  .word _label_b120
  .word _label_b197
  .word _label_a720
  .word _label_a8ea
  .word _label_b1de
  .word _label_b3e5
  .word _label_b459
  .word _label_a7a3

_label_b0db:
  lda #$01
  sta temp_var_30
  ldx #$00
  lda game_var_68
  beq _label_b0e7
  ldx #$03
_label_b0e7:
  lda a:_data_b11a_indexed,X
  sta temp_var_45
  lda a:_data_b11b_indexed,X
  sta temp_var_46
  lda a:_data_b11c_indexed,X
  sta temp_var_49
  inc temp_var_5a
  lda #$00
  sta temp_var_52
  sta temp_var_44
  sta temp_var_35
  sta temp_var_34
  lda #$08
  sta temp_var_3c
  jsr _func_b269
  lda temp_var_60
  cmp #$05
  bne _label_b112
  jsr _func_a8bb
_label_b112:
  jsr _func_b21f
  lda #$88
  sta temp_ptr_hi
  rts

_data_b11a_indexed:
.byte $40

_data_b11b_indexed:
.byte $ce

_data_b11c_indexed:
.byte $2b, $24, $ce, $2b

_label_b120:
  lda game_var_68
  bne _label_b132
  lda temp_var_ca
  beq _label_b132
  lda temp_var_46
  cmp #$B0
  bcs _label_b132
  jsr _func_b33e
  rts
_label_b132:
  jsr _func_a4fe
  lda joypad1_press
  and #$C0
  beq _label_b153
  lda #$01
  sta a:temp_var_d8
  lda #$03
  sta a:temp_var_d7
  lda joypad1_press
  and #$80
  beq _label_b150
  lda #$02
  sta a:temp_var_d7
_label_b150:
  jsr _func_e216
_label_b153:
  lda a:temp_var_5a4
  beq _label_b15b
  jsr _func_b2c0
_label_b15b:
  ldx temp_var_5e
  beq _label_b184
  lda a:temp_var_358
  cmp #$07
  bcc _label_b185
  lda a:temp_var_389,X
  sta a:temp_var_388
  lda a:temp_var_399,X
  sta a:temp_var_398
  lda #$04
  clc
  adc a:temp_var_388
  sta a:temp_var_388
  lda #$04
  clc
  adc a:temp_var_398
  sta a:temp_var_398
_label_b184:
  rts
_label_b185:
  lda frame_counter
  ror a
  and #$03
  sta temp_var_20
  lda a:temp_var_3aa
  and #$FC
  ora temp_var_20
  sta a:temp_var_3aa
  rts
_label_b197:
  lda frame_counter
  ror a
  bcs _label_b19d
  rts
_label_b19d:
  lda game_var_68
  bne _label_b1a4
  jsr _func_b33e
_label_b1a4:
  jsr _func_a6ed
  jsr _func_b2a3
  lda temp_var_5e
  beq _label_b1ca
  lda a:temp_var_358
  cmp #$07
  bcc _label_b1ca
  ldx temp_var_5e
  lda temp_var_49,X
  sta temp_var_5f
  tax
  lda a:temp_var_400,X
  ora #$40
  sta a:temp_var_400,X
  lda #$00
  sta temp_var_5e
  sta temp_var_61
_label_b1ca:
  inc temp_var_5a
  lda #$01
  sta a:temp_var_d8
  lda #$00
  sta a:temp_var_d7
  jsr _func_e216
  lda #$00
  sta temp_var_5b
  rts
_label_b1de:
  jsr _func_b98b
  rts

_func_b1e2:
  ldx temp_var_c9
  lda #$04
  sta temp_var_1f
  lda temp_var_44
  asl a
  asl a
  tay
_label_b1ed:
  lda (temp_var_42),Y
  sta temp_var_1b
  and #$F0
  sta temp_var_1c
  clc
  adc temp_var_45
  sta a:temp_var_388,X
  lda temp_var_1b
  and #$0F
  asl a
  asl a
  asl a
  asl a
  clc
  adc temp_var_46
  sta a:temp_var_398,X
  lda #$10
  and temp_var_1c
  beq _label_b218
  lda a:temp_var_398,X
  clc
  adc #$08
  sta a:temp_var_398,X
_label_b218:
  inx
  iny
  dec temp_var_1f
  bne _label_b1ed
  rts

_func_b21f:
  lda temp_var_3d
  sta temp_var_ca
  jsr _func_85a4
  lda temp_var_39
  and #$07
  sta temp_var_1d
  jsr _func_85a4
  lda temp_var_39
  and #$7F
  tay
  lda (temp_var_37),Y
  sta temp_var_1b
  ror a
  ror a
  ror a
  and #$0E
  sta temp_var_3d
  tax
  lda a:_data_f35b,X
  sta temp_var_19
  lda a:_data_f35b+1,X
  sta temp_var_1a
  lda temp_var_1b
  and #$0F
  asl a
  asl a
  tay
  ldx #$00
_label_b253:
  stx temp_var_21
  lda (temp_var_19),Y
  clc
  adc temp_var_1d
  tax
  lda a:_data_f34e_indexed,X
  ldx temp_var_21
  sta temp_var_3e,X
  iny
  inx
  cpx #$04
  bcc _label_b253
  rts

_func_b269:
  ldx temp_var_3d
  lda a:_data_f2e0,X
  sta temp_var_42
  lda a:_data_f2e0+1,X
  sta z:$43
  ldx #$00
  lda #$02
  sta temp_var_12
_label_b27b:
  stx temp_var_21
  lda temp_var_3e,X
  sta temp_var_4e,X
  sta temp_var_11
  jsr update_display_elements
  inc temp_var_12
  ldx temp_var_21
  inx
  cpx #$04
  bcc _label_b27b
  lda #$02
  sta temp_var_c9
  ldy #$00
_label_b295:
  lda (temp_var_42),Y
  clc
  adc temp_var_49
  sta a:temp_var_4a,Y
  iny
  cpy #$04
  bcc _label_b295
  rts

_func_b2a3:
  lda #$00
  sta temp_var_11
  lda #$02
  sta temp_var_12
  lda a:temp_var_35a
  cmp #$05
  bne _label_b2b4
  inc temp_var_12
_label_b2b4:
  jsr update_display_elements
  inc temp_var_12
  lda temp_var_12
  cmp #$06
  bcc _label_b2b4
  rts

_func_b2c0:
  lda frame_counter
  ror a
  bcs _label_b2c6
  rts
_label_b2c6:
  lda a:temp_var_5a4
  tax
  and #$0F
  clc
  adc a:temp_var_5b5
  sta a:temp_var_5b5
  txa
  ror a
  ror a
  ror a
  ror a
  and #$0F
  clc
  adc a:temp_var_5b4
  sta a:temp_var_5b4
  ldx #$05
_label_b2e3:
  lda a:temp_var_5b0,X
  cmp #$0A
  bcc _label_b2f5
  inc a:temp_var_5af,X
  clc
  adc #$06
  and #$0F
  sta a:temp_var_5b0,X
_label_b2f5:
  dex
  bne _label_b2e3
  lda #$06
  sta a:temp_var_5cc
  lda #$01
  sta a:temp_var_5cd
  ldx #$00
_label_b304:
  lda a:temp_var_5b0,X
  tay
  lda a:_data_f1de_indexed,Y
  sta a:temp_var_5ce,X
  inx
  cpx #$06
  bcc _label_b304
  lda game_var_68
  asl a
  tay
  ldx temp_var_35
  lda a:_data_b8b3_indexed,Y
  sta a:ppu_update_flag,X
  lda a:_data_b8b4_indexed,Y
  sta a:temp_var_339,X
  lda #$CC
  sta a:temp_var_33a,X
  lda #$05
  sta a:temp_var_33b,X
  lda #$00
  sta a:temp_var_33c,X
  sta a:temp_var_5a4
  txa
  clc
  adc #$04
  sta temp_var_35
  rts

_func_b33e:
  lda frame_counter
  ror a
  bcs _label_b344
  rts
_label_b344:
  ldy #$04
  sty temp_var_22
  lda temp_var_ca
  asl a
  asl a
  tay
_label_b34d:
  lda a:_data_b466_indexed,Y
  sta temp_var_19
  iny
  lda a:_data_b466_indexed,Y
  sta temp_var_1a
  iny
  ldx temp_var_34
  lda temp_var_19
  sta a:sprite_flag,X
  inx
  lda temp_var_1a
  sta a:sprite_flag,X
  inx
  lda #$75
  sta a:sprite_flag,X
  inx
  lda #$F2
  sta a:sprite_flag,X
  inx
  stx temp_var_34
  dec temp_var_22
  bne _label_b34d
  ldx temp_var_36
  lda #$E6
  sta a:temp_var_3b8,X
  inx
  lda #$55
  sta a:temp_var_3b8,X
  inx
  stx temp_var_36
  ldy #$00
  sty temp_var_22
  lda temp_var_3d
  asl a
  asl a
  sta temp_var_21
_label_b393:
  ldx temp_var_21
  lda a:_data_b466_indexed,X
  sta temp_var_19
  inx
  lda a:_data_b466_indexed,X
  sta temp_var_1a
  inx
  stx temp_var_21
  lda a:temp_var_3e,Y
  sta temp_var_1b
  inc temp_var_22
  asl a
  tay
  lda a:_data_f26b,Y
  sta temp_var_17
  lda a:_data_f26b+1,Y
  sta temp_var_18
  ldx temp_var_34
  lda temp_var_19
  sta a:sprite_flag,X
  inx
  lda temp_var_1a
  sta a:sprite_flag,X
  inx
  lda temp_var_17
  sta a:sprite_flag,X
  inx
  lda temp_var_18
  sta a:sprite_flag,X
  inx
  stx temp_var_34
  jsr _func_8535
  ldy temp_var_22
  cpy #$04
  bcc _label_b393
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  sta temp_var_ca
  rts
_label_b3e5:
  lda temp_var_61
  cmp #$08
  bcc _label_b400
  ldx temp_var_5f
  lda a:temp_var_400,X
  and #$BF
  sta a:temp_var_400,X
  lda #$00
  sta temp_var_61
  sta a:temp_var_358
  lda #$FF
  sta temp_var_5f
_label_b400:
  ldx #$0B
_label_b402:
  lda a:temp_var_400,X
  beq _label_b410
  inc temp_var_5a
  inc temp_var_5a
  lda #$00
  sta temp_var_5b
  rts
_label_b410:
  txa
  clc
  adc #$10
  tax
  cmp #$70
  bcc _label_b402
  lda #$00
  sta temp_var_5a
  lda temp_var_69
  bne _label_b44d
  lda temp_var_63
  bne _label_b44c
  lda temp_var_5d
  cmp #$1E
  bcc _label_b43a
  lda #$00
  sta temp_var_5d
  inc temp_var_60
  lda temp_var_60
  cmp #$05
  beq _label_b43a
  jsr _func_a86d
_label_b43a:
  lda temp_var_5c
  cmp #$C8
  bcc _label_b44c
_label_b440:
  lda #$07
  sta temp_var_5a
  lda #$00
  sta temp_var_5b
  lda #$32
  sta temp_var_52
_label_b44c:
  rts
_label_b44d:
  ldx temp_var_5f
  lda a:temp_var_400,X
  and #$40
  bne _label_b44c
  jmp _label_b440
_label_b459:
  lda #$00
  sta temp_var_8f
  lda #$09
  sta screen_mode
  lda #$00
  sta temp_var_66
  rts

_data_b466_indexed:
.byte $50, $24, $50, $24, $50, $24, $50, $24, $98, $22, $ba, $22, $d8, $22, $fa, $22
.byte $d6, $22, $b8, $22, $da, $22, $f8, $22, $f6, $22, $98, $22, $d8, $22, $18, $23
.byte $b6, $22, $ba, $22, $d8, $22, $f6, $22, $98, $22, $7a, $22, $d8, $22, $18, $23
.byte $b6, $22, $d8, $22, $ba, $22, $18, $23

_func_b49e:
  ldy #$00
  ldx #$00
_label_b4a2:
  lda a:temp_var_400,X
  and #$87
  cmp temp_var_20
  beq _label_b4af
  lda #$00
  beq _label_b4b6
_label_b4af:
  iny
  txa
  sta a:temp_var_522,Y
  lda temp_var_20
_label_b4b6:
  sta a:temp_var_471,X
  inx
  cpx #$70
  bcc _label_b4a2
  cpy #$00
  bne _label_b4c3
  rts
_label_b4c3:
  ldx a:temp_var_522,Y
  lda a:temp_var_471,X
  beq _label_b4e3
  sty temp_var_25
  ldy #$00
  sty temp_var_21
  tya
  sta a:temp_var_471,X
  txa
  sta a:temp_var_540,Y
  stx temp_var_20
  iny
  sty temp_var_55
  jsr _func_b4e7
  ldy temp_var_25
_label_b4e3:
  dey
  bne _label_b4c3
  rts

_func_b4e7:
  ldy #$06
  sty temp_var_22
  ldx #$00
  stx temp_var_24
_label_b4ef:
  ldy temp_var_22
  lda temp_var_20
  and #$10
  beq _label_b4fc
  tya
  clc
  adc #$06
  tay
_label_b4fc:
  lda a:_data_fcd3_indexed,Y
  clc
  adc temp_var_20
  tax
  and #$0F
  cmp #$0E
  bcs _label_b51f
  txa
  and #$F0
  cmp #$70
  bcs _label_b51f
  lda a:temp_var_471,X
  beq _label_b51f
  stx temp_var_23
  inc temp_var_24
  ldx temp_var_24
  cpx #$02
  bcs _label_b525
_label_b51f:
  dec temp_var_22
  bne _label_b4ef
  beq _label_b52e
_label_b525:
  inc temp_var_21
  ldx temp_var_21
  lda temp_var_20
  sta a:temp_var_559,X
_label_b52e:
  ldx temp_var_24
  beq _label_b546
  ldx temp_var_23
  lda #$00
  sta a:temp_var_471,X
  ldy temp_var_55
  txa
  sta a:temp_var_540,Y
  stx temp_var_20
  inc temp_var_55
  jmp _func_b4e7
_label_b546:
  ldx temp_var_21
  beq _label_b554
  lda a:temp_var_559,X
  dec temp_var_21
  sta temp_var_20
  jmp _func_b4e7
_label_b554:
  ldy temp_var_55
  cpy #$04
  bcc _label_b583
  tya
  clc
  adc a:temp_var_5a5
  sta a:temp_var_5a5
  tya
  sec
  sbc #$03
  asl a
  asl a
  clc
  adc a:temp_var_5a6
  sta a:temp_var_5a6
  dey
  ldx temp_var_54
_label_b572:
  lda a:temp_var_540,Y
  sta a:temp_var_568,X
  inx
  dey
  bpl _label_b572
  lda #$FF
  sta a:temp_var_568,X
  stx temp_var_54
_label_b583:
  lda #$00
  sta temp_var_55
  rts
_label_b588:
  lda frame_counter
  ror a
  bcs _label_b58e
  rts
_label_b58e:
  inc temp_var_52
  lda temp_var_52
  cmp #$04
  bcc _label_b5a7
  lda #$00
  sta temp_var_52
  sta temp_var_55
  inc temp_var_3b
  lda temp_var_3b
  cmp #$08
  bcc _label_b5a7
  inc temp_var_5b
  rts
_label_b5a7:
  ldy temp_var_55
  lda a:temp_var_568,Y
  cmp #$FF
  bne _label_b5b1
  rts
_label_b5b1:
  ldx #$00
_label_b5b3:
  sta a:temp_var_540,X
  inx
  iny
  lda a:temp_var_568,Y
  cmp #$FF
  beq _label_b5c3
  cpx #$0D
  bcc _label_b5b3
_label_b5c3:
  sty temp_var_55
  stx temp_var_24
  stx temp_var_21
  ldx #$00
  stx temp_var_34
_label_b5cd:
  ldx temp_var_34
  lda a:temp_var_540,X
  jsr _func_8511
  lda temp_var_34
  asl a
  asl a
  tay
  lda temp_var_19
  sta a:sprite_flag,Y
  lda temp_var_1a
  sta a:temp_var_301,Y
  inc temp_var_34
  dec temp_var_24
  bne _label_b5cd
  lda #$00
  sta a:temp_var_304,Y
  ldx temp_var_3b
  lda a:_data_b649_indexed,X
  cmp #$03
  bcc _label_b5fc
  jsr _func_b622
  rts
_label_b5fc:
  jsr _func_b600
  rts

_func_b600:
  asl a
  tax
  lda a:_data_f2c8,X
  sta temp_var_19
  lda a:_data_f2c8+1,X
  sta temp_var_1a
  ldx #$00
_label_b60e:
  txa
  asl a
  asl a
  tay
  lda temp_var_19
  sta a:temp_var_302,Y
  lda temp_var_1a
  sta a:temp_var_303,Y
  inx
  dec temp_var_21
  bpl _label_b60e
  rts

_func_b622:
  ldx #$00
_label_b624:
  lda a:temp_var_540,X
  stx temp_var_24
  tay
  lda a:temp_var_400,Y
  and #$07
  asl a
  tay
  txa
  asl a
  asl a
  tax
  lda a:_data_f26b,Y
  sta a:temp_var_302,X
  lda a:_data_f26b+1,Y
  sta a:temp_var_303,X
  ldx temp_var_24
  inx
  dec temp_var_21
  bpl _label_b624
  rts

_data_b649_indexed:
.byte $00, $03, $00, $03, $00, $01, $02, $00

_label_b651:
  lda #$00
  sta temp_var_22
  lda #$FF
  sta temp_var_24
_label_b659:
  lda temp_var_22
  asl a
  asl a
  asl a
  asl a
  tax
  lda #$0E
  sta temp_var_1f
_label_b664:
  lda a:temp_var_400,X
  bne _label_b699
  stx temp_var_54
  txa
  ldy temp_var_22
  sta a:temp_var_540,Y
  inx
_label_b672:
  lda a:temp_var_400,X
  beq _label_b687
  ldy temp_var_54
  sta a:temp_var_400,Y
  inc temp_var_54
  lda #$00
  sta a:temp_var_400,X
  stx temp_var_24
  inc temp_var_24
_label_b687:
  inx
  dec temp_var_1f
  bne _label_b672
  ldy temp_var_22
  lda temp_var_24
  sta a:temp_var_522,Y
  lda #$FF
  sta temp_var_24
  bmi _label_b6a5
_label_b699:
  inx
  dec temp_var_1f
  bne _label_b664
  ldy temp_var_22
  lda #$FF
  sta a:temp_var_522,Y
_label_b6a5:
  inc temp_var_22
  lda temp_var_22
  cmp #$07
  bcc _label_b659
  lda #$00
  sta temp_var_54
  inc temp_var_5b
  lda temp_var_5f
  bmi _label_b6ba
  jsr _func_b8fb
_label_b6ba:
  rts
_label_b6bb:
  lda frame_counter
  ror a
  bcs _label_b6c1
  rts
_label_b6c1:
  lda #$00
  sta temp_var_34
  lda #$08
  sta temp_var_1f
  ldy temp_var_54
_label_b6cb:
  lda a:temp_var_522,Y
  bpl _label_b6e2
_label_b6d0:
  inc temp_var_54
  ldy temp_var_54
  cpy #$07
  bcc _label_b6cb
  lda #$00
  ldx temp_var_34
  sta a:sprite_flag,X
  inc temp_var_5b
  rts
_label_b6e2:
  sta temp_var_24
  lda a:temp_var_540,Y
  sta temp_var_25
  jsr _func_8511
_label_b6ec:
  ldx temp_var_34
  lda temp_var_19
  sta a:sprite_flag,X
  inx
  lda temp_var_1a
  sta a:sprite_flag,X
  inx
  lda temp_var_25
  and #$0F
  cmp #$0B
  bcs _label_b735
  ldy temp_var_25
  lda a:temp_var_400,Y
  and #$87
  sta temp_var_1b
  bmi _label_b720
  asl a
  tay
  lda a:_data_f26b,Y
  sta a:sprite_flag,X
  inx
  lda a:_data_f26b+1,Y
  sta a:sprite_flag,X
  lda #$00
  beq _label_b72b
_label_b720:
  lda #$DA
  sta a:sprite_flag,X
  inx
  lda #$F2
  sta a:sprite_flag,X
_label_b72b:
  inx
  stx temp_var_34
  lda temp_var_1b
  beq _label_b735
  jsr _func_8535
_label_b735:
  dec temp_var_1f
  beq _label_b750
  inc temp_var_25
  lda temp_var_25
  cmp temp_var_24
  bcs _label_b6d0
  lda temp_var_19
  clc
  adc #$40
  sta temp_var_19
  bcc _label_b74c
  inc temp_var_1a
_label_b74c:
  lda #$00
  beq _label_b6ec
_label_b750:
  inc temp_var_25
  ldy temp_var_54
  lda temp_var_25
  sta a:temp_var_540,Y
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  rts
_label_b761:
  lda frame_counter
  ror a
  bcs _label_b767
  rts
_label_b767:
  lda #$00
  sta temp_var_20
  lda a:temp_var_5a6
_label_b76e:
  sec
  sbc #$0A
  bcc _label_b77d
  sta a:temp_var_5a6
  inc temp_var_20
  lda a:temp_var_5a6
  bpl _label_b76e
_label_b77d:
  lda a:temp_var_5a6
  sta a:$05AA
  lda temp_var_20
  sta a:$05A9
  ldx #$02
_label_b78a:
  lda a:temp_var_5a8,X
  cmp #$0A
  bcc _label_b79c
  inc a:temp_var_5a7,X
  clc
  adc #$06
  and #$0F
  sta a:temp_var_5a8,X
_label_b79c:
  dex
  bne _label_b78a
  lda a:temp_var_5a5
  tax
  clc
  adc temp_var_5c
  sta temp_var_5c
  txa
  clc
  adc temp_var_5d
  sta temp_var_5d
  txa
  and #$0F
  clc
  adc a:temp_var_5af
  sta a:temp_var_5af
  txa
  ror a
  ror a
  ror a
  ror a
  and #$0F
  clc
  adc a:temp_var_5ae
  sta a:temp_var_5ae
  ldx #$03
_label_b7c8:
  lda a:temp_var_5ac,X
  cmp #$0A
  bcc _label_b7da
  inc a:temp_var_5ab,X
  clc
  adc #$06
  and #$0F
  sta a:temp_var_5ac,X
_label_b7da:
  dex
  bne _label_b7c8
  ldx #$02
_label_b7df:
  lda a:temp_var_5a8,X
  clc
  adc a:temp_var_5b2,X
  sta a:temp_var_5b2,X
  dex
  bpl _label_b7df
  ldx #$04
_label_b7ee:
  lda a:temp_var_5b0,X
  cmp #$0A
  bcc _label_b800
  inc a:temp_var_5af,X
  clc
  adc #$06
  and #$0F
  sta a:temp_var_5b0,X
_label_b800:
  dex
  bne _label_b7ee
  lda #$04
  sta a:$05C0
  sta a:temp_var_5c6
  lda #$01
  sta a:$05C1
  sta a:temp_var_5c7
  ldx #$00
_label_b815:
  lda a:temp_var_5ac,X
  tay
  lda a:_data_f1de_indexed,Y
  sta a:temp_var_5c2,X
  lda a:temp_var_5a8,X
  tay
  lda a:_data_f1de_indexed,Y
  sta a:temp_var_5c8,X
  inx
  cpx #$04
  bcc _label_b815
  lda #$06
  sta a:temp_var_5cc
  lda #$01
  sta a:temp_var_5cd
  ldx #$00
_label_b83a:
  lda a:temp_var_5b0,X
  tay
  lda a:_data_f1de_indexed,Y
  sta a:temp_var_5ce,X
  inx
  cpx #$06
  bcc _label_b83a
  ldx temp_var_35
  lda game_var_68
  asl a
  tay
  lda a:_data_b8ab_indexed,Y
  sta a:ppu_update_flag,X
  lda a:_data_b8ac_indexed,Y
  sta a:temp_var_339,X
  lda #$C0
  sta a:temp_var_33a,X
  lda #$05
  sta a:temp_var_33b,X
  lda a:_data_b8af_indexed,Y
  sta a:temp_var_33c,X
  lda a:_data_b8b0_indexed,Y
  sta a:temp_var_33d,X
  lda #$C6
  sta a:temp_var_33e,X
  lda #$05
  sta a:temp_var_33f,X
  lda a:_data_b8b3_indexed,Y
  sta a:temp_var_340,X
  lda a:_data_b8b4_indexed,Y
  sta a:temp_var_341,X
  lda #$CC
  sta a:temp_var_342,X
  lda #$05
  sta a:temp_var_343,X
  lda #$00
  sta a:temp_var_344,X
  sta a:temp_var_5a5
  sta a:temp_var_5a4
  sta a:temp_var_5a6
  sta a:temp_var_5a7
  txa
  clc
  adc #$0C
  sta temp_var_35
  inc temp_var_5b
  rts

_data_b8ab_indexed:
.byte $79

_data_b8ac_indexed:
.byte $21, $22, $23

_data_b8af_indexed:
.byte $b9

_data_b8b0_indexed:
.byte $21, $42, $23

_data_b8b3_indexed:
.byte $f7

_data_b8b4_indexed:
.byte $21, $2a, $23

_label_b8b7:
  lda frame_counter
  ror a
  bcs _label_b8bd
  rts
_label_b8bd:
  lda temp_var_69
  bne _label_b8ca
  lda temp_var_58
  cmp #$05
  bne _label_b8ca
  jsr _func_b923
_label_b8ca:
  lda temp_var_59
  and #$03
  tax
  lda a:_data_b8f7_indexed,X
  sta temp_var_1b
  ldx temp_var_58
  jsr _func_b94c
  jsr _func_85dc
  lda #$00
  sta a:sprite_flag,X
  jsr _func_8535
  lda temp_var_69
  bne _label_b8ee
  dec temp_var_58
  bne _label_b8ee
  inc temp_var_59
_label_b8ee:
  lda temp_var_54
  bne _label_b8f4
  inc temp_var_5b
_label_b8f4:
  inc temp_var_5b
  rts

_data_b8f7_indexed:
.byte $03, $04, $02, $01

_func_b8fb:
  lda temp_var_5f
  tax
  and #$0F
  tay
_label_b901:
  lda a:temp_var_400,X
  and #$40
  bne _label_b90d
  dex
  dey
  bpl _label_b901
  rts
_label_b90d:
  txa
  cmp temp_var_5f
  beq _label_b922
  sec
  sbc temp_var_5f
  asl a
  asl a
  asl a
  asl a
  clc
  adc a:temp_var_398
  sta a:temp_var_398
  stx temp_var_5f
_label_b922:
  rts

_func_b923:
  ldy #$05
  lda game_var_68
  asl a
  tax
  lda a:_data_b987_indexed,X
  sta temp_var_19
  lda a:_data_b988_indexed,X
  sta temp_var_1a
  lda #$75
  sta temp_var_17
  lda #$F2
  sta temp_var_18
_label_b93b:
  jsr _func_85dc
  inc temp_var_19
  inc temp_var_19
  dey
  bne _label_b93b
  tya
  sta a:sprite_flag,X
  stx temp_var_34
  rts

_func_b94c:
  lda game_var_68
  asl a
  tay
  lda a:_data_b987_indexed,Y
  sta temp_var_19
  lda a:_data_b988_indexed,Y
  sta temp_var_1a
  lda a:temp_var_5d3,X
  asl a
  tay
  clc
  adc temp_var_19
  sta temp_var_19
  tya
  asl a
  tay
  ldx temp_var_59
  inx
  txa
  and #$02
  bne _label_b974
  tya
  clc
  adc #$14
  tay
_label_b974:
  lda #$9E
  sta temp_var_17
  lda #$F2
  sta temp_var_18
  tya
  clc
  adc temp_var_17
  sta temp_var_17
  bcc _label_b986
  inc temp_var_18
_label_b986:
  rts

_data_b987_indexed:
.byte $94

_data_b988_indexed:
.byte $20, $46, $23

_func_b98b:
  lda temp_var_5b
  jsr jump_table_engine

  .word _label_b9a4
  .word _label_b761
  .word _label_bab0
  .word _label_b588
  .word _label_b9d4
  .word _label_b8b7
  .word _label_ba6a
  .word _label_b651
  .word _label_b6bb
  .word _label_b9fe

_label_b9a4:
  lda #$00
  sta temp_var_54
  lda #$04
  sta temp_var_1e
_label_b9ac:
  lda temp_var_1e
  sta temp_var_20
  jsr _func_b49e
  dec temp_var_1e
  bne _label_b9ac
  lda a:temp_var_5a6
  bne _label_b9c9
  sta temp_var_5b
  inc temp_var_5a
  lda temp_var_62
  cmp #$03
  bcc _label_b9c8
  inc temp_var_62
_label_b9c8:
  rts
_label_b9c9:
  lda #$00
  sta temp_var_3b
  sta temp_var_52
  sta temp_var_55
  inc temp_var_5b
  rts
_label_b9d4:
  inc temp_var_5b
  jsr _func_ba30
  jsr _func_ba4a
  ldx temp_var_5f
  bmi _label_b9f5
  lda a:temp_var_400,X
  and #$40
  bne _label_b9f5
  lda #$00
  sta a:temp_var_358
  lda temp_var_69
  bne _label_b9f4
  lda #$FF
  sta temp_var_5f
_label_b9f4:
  rts
_label_b9f5:
  lda temp_var_54
  bne _label_b9fb
  inc temp_var_5b
_label_b9fb:
  inc temp_var_5b
  rts
_label_b9fe:
  lda frame_counter
  ror a
  bcs _label_ba04
  rts
_label_ba04:
  lda game_var_68
  asl a
  tay
  ldx temp_var_35
  lda a:_data_b8af_indexed,Y
  sta a:ppu_update_flag,X
  lda a:_data_b8b0_indexed,Y
  sta a:temp_var_339,X
  lda #$E8
  sta a:temp_var_33a,X
  lda #$F1
  sta a:temp_var_33b,X
  lda #$00
  sta a:temp_var_33c,X
  txa
  clc
  adc #$04
  sta temp_var_35
  lda #$00
  sta temp_var_5b
  rts

_func_ba30:
  ldx #$00
  ldy #$00
  stx temp_var_24
_label_ba36:
  ldx temp_var_24
  lda a:temp_var_568,X
  cmp #$FF
  bne _label_ba40
  rts
_label_ba40:
  tax
  tya
  sta a:temp_var_400,X
  inc temp_var_24
  bne _label_ba36
  rts

_func_ba4a:
  ldy #$00
  ldx #$6E
_label_ba4e:
  dex
_label_ba4f:
  lda a:temp_var_400,X
  beq _label_ba5b
  bpl _label_ba61
  txa
  sta a:temp_var_568,Y
  iny
_label_ba5b:
  dex
  bpl _label_ba4f
  sty temp_var_54
  rts
_label_ba61:
  txa
  and #$F0
  tax
  bne _label_ba4e
  sty temp_var_54
  rts
_label_ba6a:
  lda frame_counter
  ror a
  bcs _label_ba70
  rts
_label_ba70:
  lda #$75
  sta temp_var_17
  lda #$F2
  sta temp_var_18
  lda #$0C
  sta temp_var_1f
  ldy #$00
_label_ba7e:
  dec temp_var_54
  bpl _label_ba8a
  inc temp_var_5b
  lda #$00
  sta temp_var_52
  beq _label_baa8
_label_ba8a:
  ldx temp_var_54
  lda a:temp_var_568,X
  sta temp_var_24
  jsr _func_8511
  lda temp_var_1a
  cmp #$24
  beq _label_baa4
  ldx temp_var_24
  lda #$00
  sta a:temp_var_400,X
  jsr _func_85dc
_label_baa4:
  dec temp_var_1f
  bpl _label_ba7e
_label_baa8:
  ldx temp_var_34
  lda #$00
  sta a:sprite_flag,X
  rts
_label_bab0:
  lda #$01
  sta a:temp_var_d8
  lda #$01
  sta a:temp_var_d7
  jsr _func_e216
  inc temp_var_5b
  rts

_data_bac0:
.incbin "data/data_bac0.bin"

_data_be32:
.incbin "data/data_be32.bin"

_data_be52:
.incbin "data/data_be52.bin"

_data_bf93:
.incbin "data/data_bf93.bin"

_data_dd75:
.incbin "data/data_dd75.bin"

stop_all_music:
  lda #$00
  sta APU_SND_CHN             ; Disable all sound channels
  sta a:temp_var_700          ; Clear variable
  sta a:song_state            ; Clear song state
  rts

_func_de4b:
  lda temp_var_d2
  beq stop_all_music
  lda audio_track
  asl a
  tax
  lda a:_data_e280,X
  sta temp_var_d4
  lda a:_data_e280+1,X
  sta temp_var_d5
  ldx temp_var_d4
  ldy temp_var_d5
  jsr _func_de80          ; func_de80(e280, e280+1)
  rts

_func_de65: ; unreferenced?
; Clear $7A1 and call e1ce with song pointer
  lda #$00
  sta a:song_state            ; Clear song state
  lda audio_track
  asl a
  tax
  lda a:_data_e280,X
  sta temp_var_d4
  lda a:_data_e280+1,X
  sta temp_var_d5
  ldx temp_var_d4
  ldy temp_var_d5
  jsr _func_e1ce
  rts

_func_de80:
  lda #$00
  sta APU_SND_CHN             ; Disable all sound channels
  stx temp_var_cc
  sty z:$CD
  ldx #$3B
  lda #$00
_label_de8d:
  sta a:temp_var_711,X
  dex
  bpl _label_de8d
  sta temp_var_cb
  ldy #$08
  lda (temp_var_cc),Y
  sta a:temp_var_702
  sta a:temp_var_701
  iny
  lda (temp_var_cc),Y
  sta a:temp_var_700
  sta APU_SND_CHN
  rts

process_music_engine:
  ldy #$00
  lda (temp_var_cc),Y
  sta temp_var_ce
  iny
  lda (temp_var_cc),Y
  sta temp_var_cf
  lda #$01
  sta a:temp_var_707
  lda #$00
  sta a:temp_var_708
  jsr _func_df24
  ldy #$02
  lda (temp_var_cc),Y
  sta temp_var_ce
  iny
  lda (temp_var_cc),Y
  sta temp_var_cf
  lda #$02
  sta a:temp_var_707
  lda #$01
  sta a:temp_var_708
  jsr _func_df24
  ldy #$04
  lda (temp_var_cc),Y
  sta temp_var_ce
  iny
  lda (temp_var_cc),Y
  sta temp_var_cf
  lda #$04
  sta a:temp_var_707
  lda #$02
  sta a:temp_var_708
  jsr _func_df24
  ldy #$06
  lda (temp_var_cc),Y
  sta temp_var_ce
  iny
  lda (temp_var_cc),Y
  sta temp_var_cf
  lda #$08
  sta a:temp_var_707
  lda #$03
  sta a:temp_var_708
  jsr _func_df24
  lda a:temp_var_701
  bne _label_df20
  dec a:temp_var_711
  dec a:temp_var_712
  dec a:temp_var_713
  dec a:temp_var_714
  lda a:temp_var_702
  sta a:temp_var_701
_label_df20:
  dec a:temp_var_701
  rts

_func_df24:
  lda temp_var_cb
  and a:temp_var_707
  beq _label_df4d
  lda APU_SND_CHN
  and a:temp_var_707
  bne _label_df3c
  lda a:temp_var_707
  eor #$FF
  and temp_var_cb
  sta temp_var_cb
_label_df3c:
  lda a:temp_var_700
  and a:temp_var_707
  beq _label_df4c
  ldx a:temp_var_708
  lda a:temp_var_711,X
  beq _label_df5e
_label_df4c:
  rts
_label_df4d:
  lda a:temp_var_700
  and a:temp_var_707
  bne _label_df56
_label_df55:
  rts
_label_df56:
  ldx a:temp_var_708
  lda a:temp_var_711,X
  bne _label_df61
_label_df5e:
  jmp _label_e038
_label_df61:
  cpx #$02
  beq _label_df55
  ldy a:temp_var_71d,X
  beq _label_df55
  dec a:temp_var_741,X
  bne _label_df55
  dey
  beq _label_df7d
  dey
  beq _label_dfa0
  dey
  beq _label_dfcd
  dey
  beq _label_dfd4
  bne _label_df55
_label_df7d:
  lda a:temp_var_70d,X
  clc
  adc a:temp_var_721,X
  sta a:temp_var_721,X
  lda #$0F
  cmp a:temp_var_721,X
  beq _label_dff4
  bcs _label_df96
  sta a:temp_var_721,X
  jmp _label_dff4
_label_df96:
  lda a:temp_var_72d,X
  and #$0F
  sta a:temp_var_741,X
  bne _func_e001
_label_dfa0:
  lda a:temp_var_721,X
  sec
  sbc a:temp_var_70d,X
  sta a:temp_var_721,X
  bcs _label_dfb7
_label_dfac:
  lda a:temp_var_73d,X
  and #$0F
  sta a:temp_var_721,X
  jmp _label_dff4
_label_dfb7:
  lda a:temp_var_73d,X
  and #$0F
  cmp a:temp_var_721,X
  beq _label_dff4
  bcc _label_dfac
  lda a:temp_var_731,X
  and #$0F
  sta a:temp_var_741,X
  bne _func_e001
_label_dfcd:
  lda a:temp_var_741,X
  beq _label_dff4
  bne _func_e001
_label_dfd4:
  lda a:temp_var_721,X
  sec
  sbc a:temp_var_70d,X
  sta a:temp_var_721,X
  bcc _label_dfec
  beq _label_dfec
  lda a:temp_var_739,X
  and #$0F
  sta a:temp_var_741,X
  bne _func_e001
_label_dfec:
  ldy #$00
  tya
  sta a:temp_var_721,X
  beq _label_dffa
_label_dff4:
  ldy a:temp_var_71d,X
  jsr _func_e179
_label_dffa:
  sta a:temp_var_741,X
  tya
  sta a:temp_var_71d,X

_func_e001:
  lda a:temp_var_721,X
  pha
  lda a:temp_var_709,X
  pha
  ldy #$05
  lda #$00
_label_e00d:
  lsr a:temp_var_709,X
  bcc _label_e016
  clc
  adc a:temp_var_721,X
_label_e016:
  asl a:temp_var_721,X
  dey
  bne _label_e00d
  tay
  pla
  sta a:temp_var_709,X
  pla
  sta a:temp_var_721,X
  tya
  lsr a
  lsr a
  lsr a
  lsr a
  ora a:temp_var_729,X
  pha
  txa
  clc
  rol a
  rol a
  tay
  pla
  sta APU_PL1_VOL,Y
  rts
_label_e038:
  lda a:temp_var_715,X
  clc
  adc temp_var_ce
  sta temp_var_d0
  lda a:temp_var_719,X
  adc temp_var_cf
  sta z:$D1
  ldy #$00
  lda (temp_var_d0),Y
  bmi _label_e050
  jmp _label_e10e
_label_e050:
  cmp #$88
  bcs _label_e057
  jmp _label_e0e8
_label_e057:
  bne _label_e063
  lda #$00
  sta a:temp_var_715,X
  sta a:temp_var_719,X
  beq _label_e038
_label_e063:
  cmp #$89
  bne _label_e079
  lda a:temp_var_707
  eor #$FF
  and a:temp_var_700
  sta APU_SND_CHN
  sta a:temp_var_700
  jsr _func_e19f
  rts
_label_e079:
  cmp #$8A
  bne _label_e09b
  lda a:temp_var_745,X
  ora a:temp_var_749,X
  beq _label_e0fa
  lda a:temp_var_745,X
  sta a:temp_var_715,X
  lda a:temp_var_749,X
  sta a:temp_var_719,X
  lda #$00
  sta a:temp_var_745,X
  sta a:temp_var_749,X
  beq _label_e038
_label_e09b:
  cmp #$8B
  bne _label_e0ae
  iny
  lda (temp_var_d0),Y
  sta a:temp_var_745,X
  iny
  lda (temp_var_d0),Y
  sta a:temp_var_749,X
  jmp _label_e0fa
_label_e0ae:
  cmp #$8C
  bne _label_e0c1
  iny
  lda (temp_var_d0),Y
  sta a:temp_var_715,X
  iny
  lda (temp_var_d0),Y
  sta a:temp_var_719,X
  jmp _label_e038
_label_e0c1:
  cmp #$8D
  bne _label_e0ce
  iny
  lda (temp_var_d0),Y
  sta a:temp_var_702
  jmp _label_e0fa
_label_e0ce:
  cmp #$8E
  bne _label_e0db
  iny
  lda (temp_var_d0),Y
  sta a:temp_var_703,X
  jmp _label_e0fa
_label_e0db:
  cmp #$8F
  bne _label_e0fa
  iny
  lda (temp_var_d0),Y
  sta a:temp_var_709,X
  jmp _label_e0fa
_label_e0e8:
  and #$3F
  clc
  rol a
  rol a
  adc a:temp_var_708
  tax
  iny
  lda (temp_var_d0),Y
  sta a:temp_var_721,X
  ldx a:temp_var_708
_label_e0fa:
  iny
  tya
  clc
  adc a:temp_var_715,X
  sta a:temp_var_715,X
  lda #$00
  adc a:temp_var_719,X
  sta a:temp_var_719,X
  jmp _label_e038
_label_e10e:
  sta a:temp_var_711,X
  clc
  lda #$02
  adc a:temp_var_715,X
  sta a:temp_var_715,X
  lda #$00
  adc a:temp_var_719,X
  sta a:temp_var_719,X
  lda temp_var_cb
  and a:temp_var_707
  beq _label_e12a
  rts
_label_e12a:
  iny
  lda (temp_var_d0),Y
  pha
  txa
  clc
  rol a
  rol a
  tay
  pla
  beq _label_e13a
  clc
  adc a:temp_var_703,X
_label_e13a:
  asl a
  tax
  lda a:_data_dd75,X
  sta APU_PL1_LO,Y
  inx
  lda a:_data_dd75,X
  ora #$08
  sta APU_PL1_HI,Y
  ldx a:temp_var_708
  cpx #$02
  beq _label_e172
  lda a:temp_var_73d,X
  lsr a
  lsr a
  lsr a
  lsr a
  sta a:temp_var_721,X
  jsr _func_e001
  lda a:temp_var_725,X
  sta APU_PL1_SWEEP,Y
  ldy #$00
  jsr _func_e179
  sta a:temp_var_741,X
  tya
  sta a:temp_var_71d,X
  rts
_label_e172:
  lda a:temp_var_729,X
  sta APU_PL1_VOL,Y
_label_e178:
  rts

_func_e179:
  iny
  cpy #$05
  beq _label_e18b
  tya
  clc
  rol a
  rol a
  adc a:temp_var_708
  tax
  lda a:temp_var_729,X
  beq _func_e179
_label_e18b:
  ldx a:temp_var_708
  pha
  lsr a
  lsr a
  lsr a
  lsr a
  sta a:temp_var_70d,X
  pla
  and #$0F
  rts

_func_e19a:  ; unreferenced?
  lda a:temp_var_700
  bne _label_e178

_func_e19f:
  lda a:song_state
  beq _label_e178
  ldx #$01
_label_e1a6:
  lda a:temp_var_74d,X
  sta a:temp_var_700,X
  inx
  cpx #$4E
  bne _label_e1a6
  ldy #$00
_label_e1b3:
  lda a:temp_var_74d,X
  sta a:temp_var_cc,Y
  iny
  inx
  cpx #$54
  bne _label_e1b3
  lda a:temp_var_74d
  sta a:temp_var_700
  sta APU_SND_CHN
  lda #$00
  sta a:song_state
  rts

_func_e1ce:
  stx temp_var_7a2
  sty temp_var_7a3
  lda a:song_state
  beq _label_e1da
  rts
_label_e1da:
  lda a:temp_var_700
  sta temp_var_74d
  lda #$00
  sta a:temp_var_700
  sta APU_SND_CHN             ; Disable all sound channels
  ldx #$01
_label_e1ea:
  lda a:temp_var_700,X
  sta temp_var_74d,X
  inx
  cpx #$4E
  bne _label_e1ea
  ldy #$00
_label_e1f7:
  lda temp_var_cc,Y
  sta temp_var_74d,X
  iny
  inx
  cpx #$54
  bne _label_e1f7
  lda #$ff
  sta song_state
  ldx temp_var_7a2
  ldy temp_var_7a3
  jmp _func_de80

_data_e211_indexed:
.byte $01, $02, $04, $08, $10

_func_e216:
  pha
  txa
  pha
  tya
  pha
  lda temp_var_d8
  beq _label_e26b
  lda #$0F
  sta APU_SND_CHN
  lda #$00
  sta temp_var_cb
  lda temp_var_d7
  asl a
  tax
  lda a:_data_e290,X
  sta temp_var_d4
  lda a:_data_e290+1,X
  sta temp_var_d5
_label_e236:
  ldy #$00
  lda (temp_var_d4),Y
  tax
  lda a:_data_e211_indexed,X
  ora temp_var_cb
  sta temp_var_cb
  lda #$0F
  sta APU_SND_CHN
  txa
  asl a
  asl a
  tax
  iny
_label_e24c:
  lda (temp_var_d4),Y
  sta APU_PL1_VOL,X
  inx
  iny
  cpy #$05
  bne _label_e24c
  lda (temp_var_d4),Y
  cmp #$FF
  beq _label_e26b
  clc
  lda temp_var_d4
  adc #$05
  sta temp_var_d4
  bcc _label_e268
  inc temp_var_d5
_label_e268:
  jmp _label_e236
_label_e26b:
  lda #$00
  sta temp_var_d8
  pla
  tay
  pla
  tax
  pla
  rts
_label_e275:
  lda #$04
  sta temp_var_d7
  lda #$01
  sta temp_var_d8
  jmp _func_e216

_data_e280:
.incbin "data/data_e280.bin"
; 0xe788
; 0xea55
; 0xe2c0
; 0xe2c0
; 0xeecf
; 0xe608
; 0xefdb
; 0xf12f

_data_e290:
.incbin "data/data_e290.bin"

_data_f1de_indexed:
.byte $30

_data_f1df_indexed:
.byte $31, $32, $33, $34, $35, $36, $37, $38, $39, $04, $01, $30, $30, $30, $30, $0e
.byte $31, $2a, $28, $0e, $30, $2c, $1c, $0e, $36, $31, $17, $0e, $31, $15, $22, $0e
.byte $31, $2a, $28, $ff, $30, $25, $22, $ff, $2b, $28, $30, $ff, $31, $15, $22

_data_f20e_indexed:
.byte $00, $20, $20, $23, $23, $00, $21, $01, $01, $01, $01, $01, $21

; done
_data_f21b:
.incbin "data/data_f21b.bin"

; done
_data_f235:
.incbin "data/data_f235.bin"

; done
_data_f26b:
.incbin "data/data_f26b.bin"

; done
_data_f2c8:
.incbin "data/data_f2c8.bin"

; done
_data_f2e0:
.incbin "data/data_f2e0.bin"

_data_f34e_indexed:
.byte $01, $01, $02, $03, $04, $01, $02, $03, $04, $01, $02, $03, $04

; done
_data_f35b:
.incbin "data/data_f35b.bin"

; done
_data_f429:
.incbin "data/data_f429.bin"

; done
_data_f674:
.incbin "data/data_f674.bin"

; done
_data_faff:
.incbin "data/data_faff.bin"

; -----------------------------------------------------------------------------
; _data_fb83
; Table of little-endian 16-bit addresses (low, high) used as base positions
; for sprite/tile placement (PPU nametable addresses in the $2000 range).
; Each entry is two bytes: <low byte>, <high byte>.
; Loaded by _func_8511 which may apply a small low-byte offset based on game
; state before the value is consumed by the sprite update code (e.g., saved
; into `sprite_flag`).
; Binary source: data/data_fb83.bin
; done
_data_fb83:
.incbin "data/data_fb83.bin"

_data_fc9f_indexed:
.byte $08, $22, $a7, $fc, $e1, $23, $73, $fc, $08, $03, $45, $d5, $44, $ff, $ff, $ff
.byte $ff, $ff, $43, $4f, $d5, $54, $49, $d5, $55, $45, $43, $52, $45, $44, $49, $54
.byte $ff, $ff

_data_fcc1_indexed:
.byte $08, $22, $7d, $fc, $28, $22, $7d, $fc, $e1, $23, $78, $fc

_data_fccd_indexed:
.byte $06, $05, $04, $03, $02, $01

_data_fcd3_indexed:
.byte $00, $ef, $ff, $0f, $10, $01, $f0, $f1, $ff, $11, $10, $01, $f0

; done
_data_fce0_indexed:
.incbin "data/data_fce0.bin"

_data_fd16:
.incbin "data/data_fd16.bin"

; ============================================================================
; CHR-ROM DATA (Graphics tiles)
; ============================================================================
.segment "CHARS"
.incbin "bbb.chr"               ; 64KB of tile graphics data

; ============================================================================
; INTERRUPT VECTORS
; ============================================================================
.segment "VECTORS"
    .addr NMI                   ; $FFFA - NMI vector (VBlank interrupt)
    .addr Reset                 ; $FFFC - Reset vector (power-on/reset)
    .addr Reset                 ; $FFFE - IRQ/BRK vector (unused, points to Reset)