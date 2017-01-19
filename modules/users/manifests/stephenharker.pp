# Creates the stephenharker user
class users::stephenharker {
  govuk_user { 'stephenharker':
    fullname => 'Stephen Harker',
    email    => 'stephen.harker@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7ctK3AiOjlVc/B1ECkueKBoj9z/ty5tbzaGTosie4o1tSd2vG6JRhIkGywBDbpGTEOtkCVGbgXkSsgm/7qD9kmfp/hMw11+C9aiVNcUQACXZmeUziitv4xTONVETebaNxzsS/0rdR8fRsxVuO1eX+Cr3F+ZogOpNLMOJDVd2nqUwiqgieomNqTTJU9jtRiabh/BddbvdRbAzZahY5owNT0kjqUmJcA86F0Phn0cjwQDhMsunsAa6pYnfIi/z9R1/kUE+XxKStrJRauQAXnWOXsV/7oacDtOD70rDfyLKfNDA475Q69sMdC8XFi35QrHpI5KsLtTSTKo2Y0IZBaQ4Iv2tr47Gb4zpNcez4fPHhW/1Ia+G32V/keAD3dPGE/0R7vDq4uX+udLle/oTWd+j0dr0HelZ3aqD9gNZAivRe9bKjtSPefEQD4dGPshCMP516BTb0NW1bWQLD2Qnzw9BQgh1lDDlGW0XblYAwKIZJq/KrLiMwXmv0XHcKCG41G3/JbQrXWOP0D4BnJ7nlLrUIj6ug/zk528+kMOudfbSZQwLJX/AKQ/7Dt5MGPLR8r1XSPIDoMUlrc9iBaN6tbz1J5CqGrLyMGQahP6yjRISZzgFwp9plkj87H76ApGNmRE7PnXTUMBj7/OgksrCsrj6DkOkbyeBKkudodXEkWol9AQ== stephenharker@gds5125.local',
  }
}
