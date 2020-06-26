# hisShow

## hisShow?

2020년 1학기 모바일 앱 개발 수업에서 학기 프로젝트로 개발을 진행한 어플리케이션입니다. 한동대학교에서는 학관 출입구 등에서 공연을 예약하고 수기로 관람객 명단과 예약을 관리해야하는 어려움이 있습니다. 이 문제를 해결해보고자, 보다 쉽게 공연 관람을 예약하고 예약자들의 명단을 관리할 수 있는 어플리케이션을을 개발하였습니다.

## Environment

- **IDE :** Android Studio
- **Framework :** Flutter (Dart Language)
- **Design Prototyping Tool :** Figma
- **User Authentication :** Firebase Authentication
- **Cloud Storage :** Firebase Firestore
- **Database Management System :** Firebase Realtime Database

## Design Prototype

<img src="https://jeonyeohun.github.io/assets/post_images/hisShow_prototyping.png" />
<br>

## Database Structure

```
UserInfo
    uid
        name(String)
        phoneNum(String)

Shows
    showid
        bank(String)
        bankAccount(String)
        description(String)
        group(String)
        groupdescription(String)
        imageURL(String)
        place(String)
        price(String)
        time(DateTime)
        title(String)
        uid(String)
        resConfrim
            uid(String) : status(bool)
        reservation
            uid(String) : seatNum(String)
```

## Application Functions

어플리케이션의 각 화면과 주요기능들에 대한 요약입니다. 자세한 구현과 고민들은 개발일지에 담았습니다.

### 로그인 화면

|                                          로그인 메인화면                                           |                                                    최초 로그인                                                     |
| :------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------: |
| ![로그인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/login.png?raw=true) | ![최초 로그인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/new_user-invalid.png?raw=true) |

### 공연 목록

| 공연 목록  
| :------------------------------------------------------------------------------------------------: |
| ![로그인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/show_list.png?raw=true) |

### 공연 세부정보

|                                               공연 세부정보                                                |                                                                                                                 |
| :--------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------: |
| ![로그인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/show_detail-1.png?raw=true) | ![최초 로그인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/show_detail-2.png?raw=true) |

### 공연 예약

|                                               좌석 선택 화면                                               |                                                   좌석 선택 시                                                   |                                             확인 메세지                                              |                                             예약확정 및 입금 안내                                             |
| :--------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------: |
| ![좌석 선택 화면](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/seats.png?raw=true) | ![최초 로그인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/seats_selected.png?raw=true) | ![확인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/seats_ask.png?raw=true) | ![최초 로그인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/seats_apply.png?raw=true) |

### 예약 확인

|                                                내 공연 관리                                                |                                                    예약 미승인 상태                                                     |                                                       예약 승인 상태                                                       |
| :--------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------------: |
| ![예약 목록](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/my_reserve.png?raw=true) | ![예약 미승인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/reserve_not_confirmed.png?raw=true) | ![예약 승인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/reservation_ticket_changed.png?raw=true) |

### 예약자 관리

|                                                예약 목록                                                |                                                     예약자 관리                                                     |                                                     예약 승인                                                      |
| :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------: |
| ![예약 목록](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/my_show.png?raw=true) | ![예약자 관리](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/reservation_check.png?raw=true) | ![예약 승인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/reservation_dialog.png?raw=true) |

### 공연 등록/수정/삭제

|                                                   등록                                                   |                                                   수정                                                   |                                                  삭제                                                  |
| :------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------: |
| ![등록](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/register_show.png?raw=true) | ![예약 미승인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/modify.png?raw=true) | ![예약 승인](https://github.com/jeonyeohun/hisShow/blob/master/assets/screenshots/delete.png?raw=true) |

## Development Log

개발을 진행하며 고민했던 부분들과 구현 코드를 문서로 담았습니다.
