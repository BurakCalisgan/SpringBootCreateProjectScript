# TÜRKÇE

# 🚀 Spring Boot API Proje Oluşturma Betiği

Bu PowerShell betiği, **Spring Boot API projelerini hızlı ve otomatik olarak oluşturur**.  
Gerekli klasörleri, dosyaları ve bağımlılıkları ayarlar.  

---

## 📌 Kurulum ve Kullanım  

### **Java ve Maven Kurulumu**  
- **Java’yı [buradan](https://jdk.java.net/) indir** ve yükle.  
- **Maven’i [buradan](https://maven.apache.org/download.cgi) indir** ve yükle.  

### **Sistem Değişkenlerini Ayarla**  
- **Sistem değişkenlerine ekleyin:**  
  ```
  JAVA_HOME = C:\Program Files\Java\jdk-23
  MAVEN_HOME = C:\Program Files\Apache\Maven
  ```
- **Path değişkenine ekleyin:**  
  ```
  %JAVA_HOME%\bin  
  %MAVEN_HOME%\bin  
  ```

**Kurulumu doğrulamak için:**  
```powershell
java -version  
mvn -version  
```

---

### **PowerShell Betiğini Çalıştırma**  

Betik çalıştırma izinlerini açmak için:  
```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser  
```

Spring Boot projesini oluşturmak için:  
```powershell
./spring-boot-create-project.ps1 -ProjectName my-awesome-api -GroupId com.example -ArtifactId my-awesome-api  
```

---

### **Betiğin Oluşturacağı Yapı**  

```
my-awesome-api  
│── pom.xml  
│── src  
│   ├── main  
│   │   ├── java/com/example/myawesomeapi  
│   │   │   ├── config/  
│   │   │   ├── controller/  
│   │   │   │   ├── ExampleController.java  
│   │   │   ├── entity/  
│   │   │   ├── exception/  
│   │   │   ├── filter/  
│   │   │   ├── model/  
│   │   │   │   ├── dto/request/  
│   │   │   │   ├── dto/response/  
│   │   │   │   ├── enums/  
│   │   │   ├── repository/  
│   │   │   ├── service/  
│   │   │   ├── util/constants/  
│   │   │   ├── util/props/  
│   │   │   ├── MyAwesomeApiApplication.java  
│   │   ├── resources/  
│   │   │   ├── application.yml  
│   │   │   ├── application-db.yml  
│   │   │   ├── application-common.yml  
│   ├── test/java/com/example/myawesomeapi  
│   │   ├── MyAwesomeApiApplicationTests.java  
```

---

### **Projeyi Çalıştırma**  

```powershell
mvn spring-boot:run  
```
veya  
```powershell
java -jar target/my-awesome-api-1.0-SNAPSHOT.jar  
```

---

### **Sonuç**  

✅ **Spring Boot projesi otomatik olarak oluşturulacaktır.**  
✅ **Gerekli bağımlılıklar ve yapılandırmalar hazır olacaktır.**  
✅ **Betik sayesinde hızlı bir başlangıç yapabilirsiniz.**  

📌 **Sorularınız veya geliştirme önerileriniz için katkıda bulunabilirsiniz!** 🚀  


# ENGLISH
# 🚀 Spring Boot API Project Generator (PowerShell Script)

This PowerShell script **automatically generates a fully structured Spring Boot API project** with Maven, Java, and necessary dependencies.  
It eliminates manual setup and provides a ready-to-run Spring Boot application.  

---

## 📌 Installation and Usage  

### **Install Java and Maven**  
- **Download and install Java from [here](https://jdk.java.net/).**  
- **Download and install Maven from [here](https://maven.apache.org/download.cgi).**  

### **Set Up System Environment Variables**  
- **Add the following system variables:**  
  ```
  JAVA_HOME = C:\Program Files\Java\jdk-23
  MAVEN_HOME = C:\Program Files\Apache\Maven
  ```
- **Add these paths to the system PATH variable:**  
  ```
  %JAVA_HOME%\bin  
  %MAVEN_HOME%\bin  
  ```

**Verify the installation:**  
```powershell
java -version  
mvn -version  
```

---

### **Run the PowerShell Script**  

Enable script execution before running:  
```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser  
```

Run the script to create a Spring Boot project:  
```powershell
./spring-boot-create-project.ps1 -ProjectName my-awesome-api -GroupId com.example -ArtifactId my-awesome-api  
```

---

### **Project Structure After Running the Script**  

```
my-awesome-api  
│── pom.xml  
│── src  
│   ├── main  
│   │   ├── java/com/example/myawesomeapi  
│   │   │   ├── config/  
│   │   │   ├── controller/  
│   │   │   │   ├── ExampleController.java  
│   │   │   ├── entity/  
│   │   │   ├── exception/  
│   │   │   ├── filter/  
│   │   │   ├── model/  
│   │   │   │   ├── dto/request/  
│   │   │   │   ├── dto/response/  
│   │   │   │   ├── enums/  
│   │   │   ├── repository/  
│   │   │   ├── service/  
│   │   │   ├── util/constants/  
│   │   │   ├── util/props/  
│   │   │   ├── MyAwesomeApiApplication.java  
│   │   ├── resources/  
│   │   │   ├── application.yml  
│   │   │   ├── application-db.yml  
│   │   │   ├── application-common.yml  
│   ├── test/java/com/example/myawesomeapi  
│   │   ├── MyAwesomeApiApplicationTests.java  
```

---

### **Running the Project**  

```powershell
mvn spring-boot:run  
```
or  
```powershell
java -jar target/my-awesome-api-1.0-SNAPSHOT.jar  
```

---

### **Final Notes**  

✅ **A complete Spring Boot API project is automatically generated.**  
✅ **All required dependencies and configurations are included.**  
✅ **The script allows you to start your project instantly.**  

📌 **For questions or contributions, feel free to collaborate!** 🚀  
