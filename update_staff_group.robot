*** Settings ***
Library    SeleniumLibrary  #  ใช้ SeleniumLibrary เพื่อควบคุมเบราว์เซอร์

*** Variables ***
# กำหนดค่าตัวแปรสำหรับทดสอบ
${KEYWORD}   OPP2819  #  คีย์เวิร์ดที่ใช้ค้นหา
${AREA}      BOG-3A   #  โซนที่ต้องการเลือก
${POSITION}  HUNTER   #  ตำแหน่งที่ต้องการเลือก
${USERNAME}  99901    #  ชื่อผู้ใช้
${PASSWORD}  bambam   #  รหัสผ่าน

# เวลาหน่วง (Sleep) ที่ใช้ทั่วทั้งเทส
${SLEEP_TIME}   3s  #  ตั้งค่า Sleep เป็นตัวแปรเดียว (แก้ไขตรงนี้เพื่อปรับทุกที่)

#  URL ที่จะใช้ทดสอบ (เปลี่ยนค่าตาม ${KEYWORD} อัตโนมัติ)
${URL}  https://col_hr_web.test/staff/lists?keyword=${KEYWORD}&department_id=&all_dept_id=&position_id=&flag=1&agent_id=&nationality_id=&staff_type=&show-lock=&from=&to=&date_type=&edit_type=

*** Test Cases ***
 ทดสอบแก้ไขข้อมูลพนักงาน (Edit Record Test)
    Open Browser    ${URL}    chrome  #  เปิดเบราว์เซอร์ Chrome
    Maximize Browser Window  #  ขยายหน้าจอให้เต็ม

    #  ตรวจสอบว่าหน้าล็อกอินแสดงหรือไม่
    ${is_login}=  Run Keyword And Return Status  Wait Until Element Is Visible  css:.material-icons.prefix.pt-2  ${SLEEP_TIME}
    Run Keyword If  ${is_login}  Login To Application  #  ถ้ายังไม่ล็อกอิน ให้ทำการล็อกอิน

    Go To    ${URL}  # โหลดหน้าใหม่หลังล็อกอิน

    #  คลิกปุ่ม "แก้ไข" ในรายการพนักงาน
    Wait Until Element Is Visible    css:.tooltipped    10s
    Sleep    ${SLEEP_TIME}
    Click Element                    css:.tooltipped
    Sleep    ${SLEEP_TIME}

    #  เลือก "Staff information"
    Wait Until Element Is Visible    css:.select-dropdown    
    Sleep    ${SLEEP_TIME}
    Click Element                    css:.select-dropdown
    Sleep    ${SLEEP_TIME}
    Click Element                    xpath=//ul[contains(@class, 'dropdown-content')]//li[span[text()='- Staff information -']]
    Click Element                    xpath=//i[contains(text(), 'arrow_forward')]/parent::*

    #  เลือกโซนพื้นที่ (Area)
    Wait Until Element Is Visible    xpath=//i[contains(text(), 'arrow_forward')]    10s
    Scroll Element Into View         xpath=//i[contains(text(), 'arrow_forward')]
    Sleep    ${SLEEP_TIME}  #  รอให้หน้าโหลดเสร็จ

    #  ใช้ JavaScript เพื่อคลิกที่ ${AREA}
    Execute JavaScript    document.evaluate("//div[text()='${AREA}']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();

    Sleep    ${SLEEP_TIME}  #  รอให้โหลด

    #  เลือกตำแหน่งงาน (Position)
    Click Element    css:#select2-position_id-container
    Sleep    ${SLEEP_TIME}  #  รอให้โหลดข้อมูลใหม่
    Click Element    xpath=//li[contains(@class, 'select2-results__option') and normalize-space()='${POSITION}']
    Sleep    ${SLEEP_TIME}

    #  กดยืนยันการแก้ไข
    Click Element    xpath=//i[contains(text(), 'arrow_forward')]/parent::*
    Sleep    ${SLEEP_TIME}  #  รอให้โหลดข้อมูลใหม่

    #  ตรวจสอบว่ามีช่องเงินเดือน (salary) แสดงขึ้นมา
    Wait Until Element Is Visible    css:#salary    10s
    Sleep    ${SLEEP_TIME}  #  รอให้โหลดข้อมูลใหม่

    Close Browser  #  ปิดเบราว์เซอร์

*** Keywords ***
# 🔑 ล็อกอินเข้าสู่ระบบ (Login To Application)
Login To Application
    Wait Until Element Is Visible    css:input#username    ${SLEEP_TIME}
    Input Text    css:input#username    ${USERNAME}  #  กรอกชื่อผู้ใช้
    Input Text    css:input#password    ${PASSWORD}  #  กรอกรหัสผ่าน
    Press Keys    css:input#password    ENTER  #  กด Enter เพื่อเข้าสู่ระบบ
    Wait Until Element Is Visible    css:.sidenav-main.nav-expanded.nav-lock.nav-collapsible.sidenav-light.sidenav-active-square    20s