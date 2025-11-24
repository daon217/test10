package edu.sm.app.dto;

// 롬복(@Data 등)을 다 지우고 순수 자바로 작성
public class ZoneState {
    private int id;
    private double temp;
    private double hum;
    private boolean ac;
    private boolean heater;
    private boolean humidifier;
    private boolean dehumidifier;
    private String msg;

    // 기본 생성자
    public ZoneState() {
    }

    // 전체 생성자 (EnvironmentService에서 new ZoneState(...) 할 때 필요)
    public ZoneState(int id, double temp, double hum, boolean ac, boolean heater, boolean humidifier, boolean dehumidifier, String msg) {
        this.id = id;
        this.temp = temp;
        this.hum = hum;
        this.ac = ac;
        this.heater = heater;
        this.humidifier = humidifier;
        this.dehumidifier = dehumidifier;
        this.msg = msg;
    }

    // --- Getter & Setter (롬복 대신 직접 작성) ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public double getTemp() { return temp; }
    public void setTemp(double temp) { this.temp = temp; }

    public double getHum() { return hum; }
    public void setHum(double hum) { this.hum = hum; }

    public boolean isAc() { return ac; }
    public void setAc(boolean ac) { this.ac = ac; }

    public boolean isHeater() { return heater; }
    public void setHeater(boolean heater) { this.heater = heater; }

    public boolean isHumidifier() { return humidifier; }
    public void setHumidifier(boolean humidifier) { this.humidifier = humidifier; }

    public boolean isDehumidifier() { return dehumidifier; }
    public void setDehumidifier(boolean dehumidifier) { this.dehumidifier = dehumidifier; }

    public String getMsg() { return msg; }
    public void setMsg(String msg) { this.msg = msg; }
}