let BlabClientConfig = {
    auth: {
        grantType: 0,
        platformId: "posa-01-epostmailbox",
        clientId: "A2DD7445E6C26A3A",
        clientSecret: "CA3244ACEB547D64",
        refreshToken: ""
    },
    server: {
        baseUrl: "http://localhost:4080",
        host: "localhost",
        port: 4080
    },
    individual: {
        idn: "epostidvdevidn",
        name: "우체국개인테스터",
        eaddr: "epostidvdeveaddr#epost",
        regDate: "2021-11-01 13:23:21",
        updDate: "2021-11-09 15:22:32",
        eaddrDelDate : "2021-11-21 14:32:16",
        edocNum: "20211121_devmns1234_1547510000001",
        reason: "개인테스트사유1111"
    },
    company: {
        idn: "epostidvdevidn",
        name: "우체국법인테스터",
        eaddr: "epostcompdev#epost",
        regDate: "2021-11-02 13:23:21",
        updDate: "2021-11-10 18:22:32",
        eaddrDelDate : "2021-11-16 14:32:16",
        edocNum: "20211121_devmns1234_1547510000001",
        reason: "법인테스트사유1111"
    }
};

export default BlabClientConfig;
