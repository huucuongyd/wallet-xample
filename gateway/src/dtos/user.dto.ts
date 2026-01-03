import { IsDate, IsEmail, IsNotEmpty, IsPhoneNumber, isString, IsString } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsString()
  @IsNotEmpty()
  @IsPhoneNumber()
  phone: string;

  @IsDate()
  @IsNotEmpty()
  dateOfBirth: Date;

  @IsString()
  address: string;

  @IsString()
  @IsNotEmpty()
  zip: string;
}

export class UpdateUserDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsString()
  @IsNotEmpty()
  @IsPhoneNumber()
  phone: string;

  @IsDate()
  @IsNotEmpty()
  dateOfBirth: Date;
  
  @IsString()
  address: string;

  @IsString()
  @IsNotEmpty()
  zip: string;
}